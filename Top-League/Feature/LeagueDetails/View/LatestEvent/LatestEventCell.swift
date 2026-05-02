//
//  LatestEventCell.swift
//  Top-League
//

import UIKit

class LatestEventCell: UICollectionViewCell {

    @IBOutlet weak var cardView:       UIView!
    @IBOutlet weak var homeLogoImage:  UIImageView!
    @IBOutlet weak var awayLogoImage:  UIImageView!
    @IBOutlet weak var homeNameLabel:  UILabel!
    @IBOutlet weak var awayNameLabel:  UILabel!
    @IBOutlet weak var scoreLabel:     UILabel!
    @IBOutlet weak var dateLabel:      UILabel!
    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusLabel:    UILabel!

    static let reuseID = "LatestEventCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with event: SportEvent, sport: SportType) {
        homeNameLabel.text = event.homeTitle ?? "TBD"
        awayNameLabel.text = event.awayTitle ?? "TBD"
        scoreLabel.text    = event.finalResult ?? "- : -"
        dateLabel.text     = event.eventDate ?? ""

        let status = event.eventStatus ?? ""
        statusLabel.text       = status.isEmpty ? "FT" : status
        statusBadgeView.backgroundColor = event.isLive
            ? UIColor(hex: "#FF3B30")
            : UIColor(hex: "#1E2A45")
        statusLabel.textColor  = event.isLive ? .white : UIColor(hex: "#8E9BB5")

        loadImage(from: event.homeLogo, into: homeLogoImage, sport: sport)
        loadImage(from: event.awayLogo, into: awayLogoImage, sport: sport)
    }

    private func loadImage(from urlString: String?, into imageView: UIImageView, sport: SportType) {
        let placeholder = sport == .tennis ? "person.circle.fill" : "shield.fill"
        imageView.image = UIImage(systemName: placeholder)
        imageView.tintColor = UIColor(hex: "#2A3A5C")
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                await MainActor.run { imageView.image = UIImage(data: data) }
            } catch { }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        homeLogoImage.image = nil
        awayLogoImage.image = nil
        scoreLabel.text     = nil
    }
}
