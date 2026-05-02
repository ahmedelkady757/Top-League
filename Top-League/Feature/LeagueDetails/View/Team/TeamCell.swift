//
//  TeamCell.swift
//  Top-League
//

import UIKit

class TeamCell: UICollectionViewCell {

    @IBOutlet weak var cardView:       UIView!
    @IBOutlet weak var logoImageView:  UIImageView!
    @IBOutlet weak var ringView:       UIView!
    @IBOutlet weak var teamNameLabel:  UILabel!

    static let reuseID = "TeamCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with team: Team, accentColor: UIColor = UIColor(hex: "#F5C518"), sport: SportType) {
        teamNameLabel.text = team.teamName ?? "Team"
        loadImage(from: team.teamLogo, sport: sport)
    }

    private func loadImage(from urlString: String?, sport: SportType) {
        let placeholder = sport == .tennis ? "person.circle.fill" : "shield.fill"
        logoImageView.image    = UIImage(systemName: placeholder)
        logoImageView.tintColor = UIColor(hex: "#2A3A5C")
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                await MainActor.run { self.logoImageView.image = UIImage(data: data) }
            } catch { }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
}
