//
//  UpcomingEventCell.swift
//  Top-League
//

import UIKit

class UpcomingEventCell: UICollectionViewCell {

    // MARK: - IBOutlets (connected in UpcomingEventCell.xib)
    @IBOutlet weak var cardView:       UIView!
    @IBOutlet weak var homeLogoImage:  UIImageView!
    @IBOutlet weak var awayLogoImage:  UIImageView!
    @IBOutlet weak var homeNameLabel:  UILabel!
    @IBOutlet weak var vsLabel:        UILabel!
    @IBOutlet weak var awayNameLabel:  UILabel!
    @IBOutlet weak var dateLabel:      UILabel!
    @IBOutlet weak var timeLabel:      UILabel!
    @IBOutlet weak var liveBadgeView:  UIView!
    @IBOutlet weak var liveBadgeLabel: UILabel!

    // MARK: - Reuse ID
    static let reuseID = "UpcomingEventCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with event: SportEvent, sport: SportType) {
        homeNameLabel.text = event.homeTitle ?? "TBD"
        awayNameLabel.text = event.awayTitle ?? "TBD"
        dateLabel.text     = event.eventDate ?? ""
        timeLabel.text     = formatTime12Hour(event.eventTime)
        liveBadgeView.isHidden = !event.isLive
        if event.isLive { startLivePulse() }

        loadImage(from: event.homeLogo, into: homeLogoImage, sport: sport)
        loadImage(from: event.awayLogo, into: awayLogoImage, sport: sport)
    }

    private func formatTime12Hour(_ timeString: String?) -> String {
        guard let timeStr = timeString, !timeStr.isEmpty else { return "" }
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        let formats = ["HH:mm", "HH:mm:ss"]
        for f in formats {
            df.dateFormat = f
            if let date = df.date(from: timeStr) {
                df.dateFormat = "h:mm a"
                return df.string(from: date)
            }
        }
        return timeStr
    }

    // MARK: - Image Loading
    private func loadImage(from urlString: String?, into imageView: UIImageView, sport: SportType) {
        let placeholder = sport == .tennis ? "person.circle.fill" : "shield.fill"
        imageView.image = UIImage(systemName: placeholder)
        imageView.tintColor = UIColor(hex: "#8E9BB5")
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                await MainActor.run {
                    imageView.image = UIImage(data: data)
                }
            } catch { }
        }
    }

    private func startLivePulse() {
        liveBadgeView.alpha = 1
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: [.autoreverse, .repeat, .curveEaseInOut],
            animations: { self.liveBadgeView.alpha = 0.3 }
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        liveBadgeView.layer.removeAllAnimations()
        liveBadgeView.alpha = 1
        homeLogoImage.image = nil
        awayLogoImage.image = nil
    }
}

extension UIColor {
    convenience init(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if h.hasPrefix("#") { h.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8)  & 0xFF) / 255
        let b = CGFloat(rgb         & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
