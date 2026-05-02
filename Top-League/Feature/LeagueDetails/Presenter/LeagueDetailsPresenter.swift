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

        let leagueId   = String(league.id ?? 0)
        let today      = DateHelper.today()
        let pastDate   = DateHelper.daysAgo(30)
        let futureDate = DateHelper.daysAhead(30)

        configureViewForSport()
        view?.updateFavoriteButton(isFavorite: isFavorite())

        networkService.fetchEvents(sport: sport, leagueId: leagueId, from: today, to: futureDate) { [weak self] events, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let events = events {
                    self.upcomingEvents = events
                    self.view?.reloadUpcomingEvents()
                }
                self.checkEmptyState()
            }
        }

        networkService.fetchEvents(sport: sport, leagueId: leagueId, from: pastDate, to: today) { [weak self] events, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let events = events {
                    self.latestEvents = events
                    self.view?.reloadLatestEvents()
                }
                self.view?.hideLoading()
                self.checkEmptyState()
            }
        }

        if sport.hasTeams {
            networkService.fetchTeams(leagueId: leagueId, sport: sport) { [weak self] teams, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let teams = teams, !teams.isEmpty {
                        self.teams = teams
                        self.view?.showTeamsSection()
                    }
                }
            }
        }
    }

    private func configureViewForSport() {
        view?.setScoreLabel(sport.scoreLabel)

        if !sport.hasTeams {
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
