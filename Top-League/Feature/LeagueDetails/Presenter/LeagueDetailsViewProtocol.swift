//
//  LeagueDetailsViewProtocol.swift
//  Top-League
//

import Foundation

/// The View contract that LeagueDetailsViewController must conform to.
/// The Presenter calls these methods to update the UI — it never touches UIKit directly.
protocol LeagueDetailsViewProtocol: AnyObject {

    // MARK: - Collection View Reloads
    /// Reload the upcoming events horizontal collection view
    func reloadUpcomingEvents()

    /// Reload the latest results collection view
    func reloadLatestEvents()

    // MARK: - Teams Section Visibility
    /// Show the Teams section (Football, Basketball, Cricket)
    func showTeamsSection()

    /// Hide the Teams section entirely (Tennis — no team data)
    func hideTeamsSection()

    // MARK: - Sport-Specific UI
    /// Update the score column header label ("Goals" / "Points" / "Runs" / "Sets")
    func setScoreLabel(_ text: String)

    /// Show the match-format badge (Cricket only — T20 / ODI / Test)
    func showMatchFormatBadge()

    // MARK: - Favorite Button
    /// Toggle the star icon in the navigation bar
    func updateFavoriteButton(isFavorite: Bool)

    // MARK: - States
    /// Show a placeholder view when both upcoming & latest events are empty
    func showEmptyState()

    /// Show loading indicator
    func showLoading()

    /// Hide loading indicator
    func hideLoading()

    /// Show an error alert with the given message
    func showError(message: String)
}
