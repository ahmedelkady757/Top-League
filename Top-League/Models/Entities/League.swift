//
//  League.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct League: Codable {
    let id: String?
    let name: String?
    let countryKey: String?
    let countryName: String?

    enum CodingKeys: String, CodingKey {
        case id           = "league_key"
        case name         = "league_name"
        case countryKey   = "country_key"
        case countryName  = "country_name"
    }
}
