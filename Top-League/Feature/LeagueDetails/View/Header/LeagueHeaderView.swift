//
//  LeagueHeaderView.swift
//  Top-League
//

import UIKit

class LeagueHeaderView: UIView {
    
    @IBOutlet weak var leagueLogoImage:  UIImageView!
    @IBOutlet weak var leagueNameLabel:  UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var formatBadgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(league: League, badgeData: Data?) {
        leagueNameLabel.text = league.name ?? ""
        countryNameLabel.text = league.countryName ?? ""
        
        if let data = badgeData {
            leagueLogoImage.image = UIImage(data: data)
        }
    }
}
