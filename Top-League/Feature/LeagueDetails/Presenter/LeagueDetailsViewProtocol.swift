//
//  LeagueDetailsViewProtocol.swift
//  Top-League
//

import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {

    func reloadUpcomingEvents()

    func reloadLatestEvents()

    func showTeamsSection()

    func hideTeamsSection()

    func setScoreLabel(_ text: String)

    func showMatchFormatBadge()

    func updateFavoriteButton(isFavorite: Bool)

    func showEmptyState()

    func showLoading()

    func hideLoading()

    func showError(message: String)
}
