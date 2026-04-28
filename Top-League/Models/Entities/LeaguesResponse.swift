//
//  LeaguesResponse.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct LeaguesResponse: Codable {
    let leagues: [League]?
    
    enum CodingKeys: String, CodingKey {
        case leagues = "result"
    }
}
