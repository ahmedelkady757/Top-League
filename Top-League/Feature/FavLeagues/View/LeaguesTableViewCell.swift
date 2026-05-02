//
//  LeaguesTableViewCell.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 30/04/2026.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        leagueImage.layer.cornerRadius = leagueImage.frame.size.width / 2
        leagueImage.clipsToBounds = true
        leagueImage.contentMode = .scaleAspectFill

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(name : String, image : Data?){
        leagueName.text = name
        guard let image = image else { return }
        leagueImage.image = UIImage(data: image)
    }
    
}
