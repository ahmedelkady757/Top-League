//
//  League.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct League: Codable {
    let id: Int?
    let name: String?
    let countryKey: Int?
    let countryName: String?
    let badgeURL: String?
    let countryLogoURL: String?

    enum CodingKeys: String, CodingKey {
        case id             = "league_key"
        case name           = "league_name"
        case countryKey     = "country_key"
        case countryName    = "country_name"
        case badgeURL       = "league_logo"
        case countryLogoURL = "country_logo"
    }
}
