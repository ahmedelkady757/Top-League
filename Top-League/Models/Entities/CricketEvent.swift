//
//  CricketEvent.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct CricketEvent: Codable, SportEvent {
    let eventKey: Int?
    let eventDateStart: String?
    let eventDateStop: String?
    let eventTime: String?
    let homeTeam: String?
    let awayTeam: String?
    let homeFinalResult: String?
    let awayFinalResult: String?
    let eventStatus: String?
    let eventStatusInfo: String?
    let leagueName: String?
    let leagueKey: Int?
    let eventType: String?
    let eventToss: String?
    let homeLogo: String?
    let awayLogo: String?

    var eventDate: String? { eventDateStart }
    var finalResult: String? { "\(homeFinalResult ?? "-") / \(awayFinalResult ?? "-")" }
    var homeTitle: String? { homeTeam }
    var awayTitle: String? { awayTeam }

    enum CodingKeys: String, CodingKey {
        case eventKey         = "event_key"
        case eventDateStart   = "event_date_start"
        case eventDateStop    = "event_date_stop"
        case eventTime        = "event_time"
        case homeTeam         = "event_home_team"
        case awayTeam         = "event_away_team"
        case homeFinalResult  = "event_home_final_result"
        case awayFinalResult  = "event_away_final_result"
        case eventStatus      = "event_status"
        case eventStatusInfo  = "event_status_info"
        case leagueName       = "league_name"
        case leagueKey        = "league_key"
        case eventType        = "event_type"
        case eventToss        = "event_toss"
        case homeLogo         = "event_home_team_logo"
        case awayLogo         = "event_away_team_logo"
    }
}
