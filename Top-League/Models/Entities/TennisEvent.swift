//
//  TennisEvent.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//
struct TennisEvent: Codable, SportEvent {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let firstPlayer: String?
    let secondPlayer: String?
    let finalResult: String?
    let eventStatus: String?
    let leagueName: String?
    let leagueKey: Int?
    let eventWinner: String?
    let firstPlayerLogo: String?
    let secondPlayerLogo: String?
    let scores: [TennisScore]?

    var homeLogo: String? { firstPlayerLogo }
    var awayLogo: String? { secondPlayerLogo }
    var homeTitle: String? { firstPlayer }
    var awayTitle: String? { secondPlayer }

    enum CodingKeys: String, CodingKey {
        case eventKey       = "event_key"
        case eventDate      = "event_date"
        case eventTime      = "event_time"
        case firstPlayer    = "event_first_player"
        case secondPlayer   = "event_second_player"
        case finalResult    = "event_final_result"
        case eventStatus    = "event_status"
        case leagueName     = "league_name"
        case leagueKey      = "league_key"
        case eventWinner    = "event_winner"
        case firstPlayerLogo  = "event_first_player_logo"
        case secondPlayerLogo = "event_second_player_logo"
        case scores         = "scores"
    }
}

struct TennisScore: Codable {
    let scoreFirst: String?
    let scoreSecond: String?
    let scoreSet: String?

    enum CodingKeys: String, CodingKey {
        case scoreFirst   = "score_first"
        case scoreSecond  = "score_second"
        case scoreSet     = "score_set"
    }
}
