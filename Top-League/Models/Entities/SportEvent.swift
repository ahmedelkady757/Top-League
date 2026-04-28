//
//  SportEvent.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

protocol SportEvent {
    var eventKey: Int? { get }
    var eventDate: String? { get }
    var eventTime: String? { get }
    var finalResult: String? { get }
    var eventStatus: String? { get }
    var leagueName: String? { get }
    var leagueKey: Int? { get }
    var homeLogo: String? { get }
    var awayLogo: String? { get }
    var homeTitle: String? { get }
    var awayTitle: String? { get }
}
