//
//  LeagueDetailsPresenter.swift
//  Top-League
//

import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    weak var view: LeagueDetailsViewProtocol?

    private let networkService: NetworkService
    private let league: League
    private let sport: SportType

    private var upcomingEvents: [SportEvent] = []
    private var latestEvents:   [SportEvent] = []
    private var teams:          [Team]       = []

    init(league: League, sport: SportType, networkService: NetworkService = AlamofireNetworkService.shared) {
        self.league         = league
        self.sport          = sport
        self.networkService = networkService
    }

    func loadLeagueDetails() {
        view?.showLoading()
        configureViewForSport()
        view?.updateFavoriteButton(isFavorite: isFavorite())

        let leagueId   = String(league.id ?? 0)
        let leagueIdInt = league.id ?? 0
        let today      = DateHelper.today()
        let pastDate   = DateHelper.daysAgo(30)
        let futureDate = DateHelper.daysAhead(30)
        let sport      = self.sport
        let service    = self.networkService as! AlamofireNetworkService

        Task {
            // Fire all 3 requests in TRUE parallel using async let
            async let upcomingFetch = service.fetchEventsAsync(sport: sport, leagueId: leagueId, from: today, to: futureDate)
            async let latestFetch   = service.fetchEventsAsync(sport: sport, leagueId: leagueId, from: pastDate, to: today)
            async let teamsFetch    = fetchTeamsOrPlayers(service: service, leagueId: leagueId, sport: sport)

            // Await all results (runs concurrently in background)
            let (fetchedUpcoming, fetchedLatest, fetchedTeams) = await (upcomingFetch, latestFetch, teamsFetch)

            // Process on background — never blocks the main thread
            let processed = await Task.detached(priority: .userInitiated) { () -> ([SportEvent], [SportEvent]) in
                // For tennis: filter by leagueKey since API doesn't support leagueId param
                let upcoming = sport == .tennis
                    ? fetchedUpcoming.filter { ($0 as? TennisEvent)?.leagueKey == leagueIdInt }
                    : fetchedUpcoming
                let latest = sport == .tennis
                    ? fetchedLatest.filter { ($0 as? TennisEvent)?.leagueKey == leagueIdInt }
                    : fetchedLatest

                var uniqueEvents: [Int: SportEvent] = [:]
                var eventsWithoutKey: [SportEvent] = []

                (upcoming + latest).forEach { event in
                    if let key = event.eventKey {
                        uniqueEvents[key] = event
                    } else {
                        eventsWithoutKey.append(event)
                    }
                }
                let allUnique = Array(uniqueEvents.values) + eventsWithoutKey

                let now = Date()
                var upcomingOut: [SportEvent] = []
                var latestOut:   [SportEvent] = []

                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US_POSIX")
                let formats = ["yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd hh:mm a"]

                func parseDate(_ dateStr: String, _ timeStr: String) -> Date? {
                    let tStr = timeStr.isEmpty ? "00:00" : timeStr
                    for f in formats {
                        df.dateFormat = f
                        if let d = df.date(from: "\(dateStr) \(tStr)") { return d }
                    }
                    return nil
                }

                for event in allUnique {
                    let d = event.eventDate ?? ""; let t = event.eventTime ?? ""
                    if let date = parseDate(d, t) {
                        if date > now || (event.isUpcoming && (t.isEmpty || t == "00:00")) {
                            upcomingOut.append(event)
                        } else if event.isUpcoming && date > now.addingTimeInterval(-7200) {
                            upcomingOut.append(event)
                        } else {
                            latestOut.append(event)
                        }
                    } else {
                        if event.isUpcoming { upcomingOut.append(event) } else { latestOut.append(event) }
                    }
                }

                let sortedUpcoming = upcomingOut.sorted {
                    (parseDate($0.eventDate ?? "", $0.eventTime ?? "") ?? .distantFuture) <
                    (parseDate($1.eventDate ?? "", $1.eventTime ?? "") ?? .distantFuture)
                }
                let sortedLatest = latestOut.sorted {
                    (parseDate($0.eventDate ?? "", $0.eventTime ?? "") ?? .distantPast) >
                    (parseDate($1.eventDate ?? "", $1.eventTime ?? "") ?? .distantPast)
                }
                return (sortedUpcoming, sortedLatest)
            }.value

            // Update model and UI on main thread
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.teams          = fetchedTeams
                self.upcomingEvents = processed.0
                self.latestEvents   = processed.1
                self.view?.reloadUpcomingEvents()
                self.view?.reloadLatestEvents()
                if !fetchedTeams.isEmpty { self.view?.showTeamsSection() }
                self.view?.hideLoading()
                self.checkEmptyState()
            }
        }
    }

    // Helper to avoid broken async let closure syntax
    private func fetchTeamsOrPlayers(service: AlamofireNetworkService, leagueId: String, sport: SportType) async -> [Team] {
        if sport.hasTeams {
            return await service.fetchTeamsAsync(leagueId: leagueId, sport: sport)
        } else if sport == .tennis {
            let players = await service.fetchPlayersAsync(leagueId: leagueId)
            return players.map { Team(teamKey: $0.playerKey, teamName: $0.playerName, teamLogo: $0.playerImage, players: nil) }
        }
        return []
    }


    private func configureViewForSport() {
        view?.setScoreLabel(sport.scoreLabel)

        if !sport.hasTeams && sport != .tennis {
            view?.hideTeamsSection()
        }

        if sport == .cricket {
            view?.showMatchFormatBadge()
        }
    }

    private func checkEmptyState() {
        if upcomingEvents.isEmpty && latestEvents.isEmpty {
            view?.showEmptyState()
        }
    }

    func getUpcomingCount() -> Int             { upcomingEvents.count }
    func getUpcomingEvent(at index: Int) -> SportEvent { upcomingEvents[index] }

    func getLatestCount() -> Int               { latestEvents.count }
    func getLatestEvent(at index: Int) -> SportEvent   { latestEvents[index] }

    func getTeamsCount() -> Int                { teams.count }
    func getTeam(at index: Int) -> Team        { teams[index] }

    func toggleFavorite() {
        guard let id = league.id else { return }
        if isFavorite() {
            CoreDataManager.shared.deleteLeague(id: id)
            view?.updateFavoriteButton(isFavorite: false)
        } else {
            fetchImageData(from: league.badgeURL ?? "") { [weak self] data in
                guard let self = self, let id = self.league.id else { return }
                CoreDataManager.shared.saveLeague(
                    id:      id,
                    name:    self.league.name ?? "",
                    image:   data ?? Data(),
                    sportId: self.league.countryKey ?? 0
                )
                DispatchQueue.main.async {
                    self.view?.updateFavoriteButton(isFavorite: true)
                }
            }
        }
    }

    func isFavorite() -> Bool {
        guard let id = league.id else { return false }
        return CoreDataManager.shared.isLeagueSaved(id: id)
    }

    func fetchImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil); return }
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    await MainActor.run { completion(nil) }
                    return
                }
                await MainActor.run { completion(data) }
            } catch {
                print("Image load error: \(error.localizedDescription)")
                await MainActor.run { completion(nil) }
            }
        }
    }
}

private enum DateHelper {
    static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func today() -> String          { formatter.string(from: Date()) }
    static func daysAgo(_ n: Int) -> String {
        let d = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
        return formatter.string(from: d)
    }
    static func daysAhead(_ n: Int) -> String {
        let d = Calendar.current.date(byAdding: .day, value: n, to: Date()) ?? Date()
        return formatter.string(from: d)
    }
}
