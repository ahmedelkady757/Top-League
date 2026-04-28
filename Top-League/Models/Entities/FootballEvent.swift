//
//  FootballEvent.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//
struct FootballEvent: Codable, SportEvent {
    var eventKey: Int?
    var leagueKey: Int?
    let eventDate: String?
    let eventTime: String?
    let homeTeam: String?
    let awayTeam: String?
    let finalResult: String?
    let eventStatus: String?
    let leagueName: String?
    private let homeLogoFootball: String?
    private let awayLogoFootball: String?
    private let homeLogoBasketball: String?
    private let awayLogoBasketball: String?

    var homeLogo: String? { homeLogoFootball ?? homeLogoBasketball }
    var awayLogo: String? { awayLogoFootball ?? awayLogoBasketball }
    var homeTitle: String? { homeTeam }
    var awayTitle: String? { awayTeam }

    enum CodingKeys: String, CodingKey {
        case eventKey        = "event_key"
        case eventDate       = "event_date"
        case eventTime       = "event_time"
        case homeTeam        = "event_home_team"
        case awayTeam        = "event_away_team"
        case finalResult     = "event_final_result"
        case eventStatus     = "event_status"
        case leagueName      = "league_name"
        case leagueKey       = "league_key"
        case homeLogoFootball    = "home_team_logo"
        case awayLogoFootball    = "away_team_logo"
        case homeLogoBasketball  = "event_home_team_logo"
        case awayLogoBasketball  = "event_away_team_logo"
    }
}
