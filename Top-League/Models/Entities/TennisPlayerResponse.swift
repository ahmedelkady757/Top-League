//
//  TennisPlayerResponse.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct TennisPlayerResponse: Codable {
    let players: [TennisPlayer]?

    enum CodingKeys: String, CodingKey {
        case players = "result"
    }
}
