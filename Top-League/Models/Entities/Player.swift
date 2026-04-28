//
//  Player.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct Player: Codable {
    let playerKey: Int?
    let playerName: String?
    let playerImage: String?
    let playerNumber: String?
    let playerType: String?
    let playerAge: String?
    let playerBirthdate: String?
    let playerInjured: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerAssists: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    let playerRating: String?
    let playerIsCaptain: String?

    enum CodingKeys: String, CodingKey {
        case playerKey         = "player_key"
        case playerName        = "player_name"
        case playerImage       = "player_image"
        case playerNumber      = "player_number"
        case playerType        = "player_type"
        case playerAge         = "player_age"
        case playerBirthdate   = "player_birthdate"
        case playerInjured     = "player_injured"
        case playerMatchPlayed = "player_match_played"
        case playerGoals       = "player_goals"
        case playerAssists     = "player_assists"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards    = "player_red_cards"
        case playerRating      = "player_rating"
        case playerIsCaptain   = "player_is_captain"
    }
}
