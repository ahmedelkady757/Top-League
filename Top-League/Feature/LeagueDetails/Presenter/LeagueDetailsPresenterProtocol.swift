//
//  LeagueDetailsPresenterProtocol.swift
//  Top-League
//

import Foundation

protocol LeagueDetailsPresenterProtocol: AnyObject {

    var view: LeagueDetailsViewProtocol? { get set }

    func loadLeagueDetails()

    func getUpcomingCount() -> Int
    func getUpcomingEvent(at index: Int) -> SportEvent

    func getLatestCount() -> Int
    func getLatestEvent(at index: Int) -> SportEvent

    func getTeamsCount() -> Int
    func getTeam(at index: Int) -> Team

    func toggleFavorite()
    func isFavorite() -> Bool

    func fetchImageData(from urlString: String, completion: @escaping (Data?) -> Void)
}
