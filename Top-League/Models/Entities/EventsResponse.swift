//
//  EventsResponse.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

struct FootballEventsResponse: Codable {
    let events: [FootballEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "result"
    }
}

struct TennisEventsResponse: Codable {
    let events: [TennisEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "result"
    }
}

struct CricketEventsResponse: Codable {
    let events: [CricketEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "result"
    }
}
