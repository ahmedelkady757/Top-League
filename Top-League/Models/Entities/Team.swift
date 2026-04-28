//
//  Team.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct Team: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    
    let players: [Player]?

    enum CodingKeys: String, CodingKey {
        case teamKey  = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players  = "players"
    }
}
