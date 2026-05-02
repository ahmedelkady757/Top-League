//
//  SportEvent.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

import Foundation

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

extension SportEvent {
    var isUpcoming: Bool {
        return finalResult == nil || eventStatus?.lowercased() == "upcoming" || eventStatus?.isEmpty == true
    }
    
    var isLive: Bool {
        let status = eventStatus?.lowercased() ?? ""
        let liveStatuses = ["live", "1", "in progress", "playing", "ht", "1h", "2h", "halftime", "running", "started"]
        if liveStatuses.contains(status) { return true }
        
        // Many APIs return the current match minute as the status (e.g., "45", "89", "12'")
        let cleanedStatus = status.replacingOccurrences(of: "'", with: "")
        if Int(cleanedStatus) != nil { return true }
        
        return false
    }
}
