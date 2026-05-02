//
//  LeagueDetailsPresenterProtocol.swift
//  Top-League
//

import Foundation

/// The Presenter contract that LeagueDetailsPresenter must implement.
/// The ViewController calls these methods — it never holds raw data arrays.
protocol LeagueDetailsPresenterProtocol: AnyObject {

    // MARK: - View Reference
    var view: LeagueDetailsViewProtocol? { get set }

    // MARK: - Entry Point
    /// Kick off all network fetches and configure the view for the current sport
    func loadLeagueDetails()

    // MARK: - Upcoming Events Data Source
    func getUpcomingCount() -> Int
    func getUpcomingEvent(at index: Int) -> SportEvent

    // MARK: - Latest Events Data Source
    func getLatestCount() -> Int
    func getLatestEvent(at index: Int) -> SportEvent

    // MARK: - Teams Data Source
    func getTeamsCount() -> Int
    func getTeam(at index: Int) -> Team

    // MARK: - Favorite
    func toggleFavorite()
    func isFavorite() -> Bool

    // MARK: - Image Loading
    /// Shared utility: downloads image data and delivers on main thread
    func fetchImageData(from urlString: String, completion: @escaping (Data?) -> Void)
}
