//
//  TeamsResponse.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct TeamsResponse: Codable {
    let teams: [Team]?
    
    enum CodingKeys: String, CodingKey {
        case teams = "result"
    }
}
