//
//  NetworkService.swift
//  Top-League
//
//  Created by JETSMobileLabMini6 on 30/04/2026.
//

import Foundation
import Alamofire

protocol NetworkService {
    
    func fetchLeagues(sport: SportType, completion: @escaping ([League]?, Error?) -> Void)
    
    func fetchEvents(
        sport: SportType,
        leagueId: String,
        from: String,
        to: String,
        completion: @escaping ([SportEvent]?, Error?) -> Void
    )
    
    func fetchTeams(leagueId: String, sport: SportType, completion: @escaping ([Team]?, Error?) -> Void)
    
    func fetchTeamDetails(teamId: String, sport: SportType, completion: @escaping (Team?, Error?) -> Void)
}

class AlamofireNetworkService: NetworkService {

    
    static let shared = AlamofireNetworkService()
    
    private init() {}

    private var apiKey: String {
            return APIKeyManager.shared.apiKey
        }
    
    private struct ApiResponse<T: Decodable>: Decodable {
        let result: [T]?
    }

    
    private func performRequest<T: Decodable>(
        url: String,
        parameters: [String: Any],
        completion: @escaping ([T]?, Error?) -> Void
    ) {
        var params = parameters
        params["APIkey"] = apiKey
        
        AF.request(url, parameters: params).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                    completion(decodedResponse.result, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }


    func fetchLeagues(sport: SportType, completion: @escaping ([League]?, Error?) -> Void) {
        let params: [String: Any] = ["met": "Leagues"]
        performRequest(url: sport.baseURL, parameters: params, completion: completion)
    }

    
    func fetchEvents(
        sport: SportType,
        leagueId: String,
        from: String,
        to: String,
        completion: @escaping ([SportEvent]?, Error?) -> Void
    ) {
        var params: [String: Any] = [
            "met": "Fixtures",
            "from": from,
            "to": to
        ]

        if sport != .tennis {
            params["leagueId"] = leagueId
        }

        switch sport {
        case .football, .basketball:
            performRequest(url: sport.baseURL, parameters: params) { (events: [FootballEvent]?, error) in
                completion(events, error)
            }
        case .cricket:
            performRequest(url: sport.baseURL, parameters: params) { (events: [CricketEvent]?, error) in
                completion(events, error)
            }
        case .tennis:
            performRequest(url: sport.baseURL, parameters: params) { (events: [TennisEvent]?, error) in
                completion(events, error)
            }
        }
    }
    

    func fetchTeams(leagueId: String, sport: SportType, completion: @escaping ([Team]?, Error?) -> Void) {
        if sport == .tennis {
            completion([], nil)
            return
        }

        let params: [String: Any] = [
            "met": "Teams",
            "leagueId": leagueId
        ]
        
        performRequest(url: sport.baseURL, parameters: params, completion: completion)
    }

    
    func fetchTeamDetails(teamId: String, sport: SportType, completion: @escaping (Team?, Error?) -> Void) {
        let params: [String: Any] = [
            "met": "Teams",
            "teamId": teamId
        ]

        performRequest(url: sport.baseURL, parameters: params) { (teams: [Team]?, error) in
            completion(teams?.first, error)
        }
    }
}
