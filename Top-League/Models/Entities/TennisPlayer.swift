//
//  TennisPlayer.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct TennisPlayer: Codable {
    let playerKey: Int?
    let playerName: String?
    let playerCountry: String?
    let playerLogo: String?

    enum CodingKeys: String, CodingKey {
        case playerKey     = "player_key"
        case playerName    = "player_name"
        case playerCountry = "player_country"
        case playerLogo    = "player_logo"
    }
}
