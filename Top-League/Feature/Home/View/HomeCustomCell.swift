//
//  HomeCustomCellCollectionViewCell.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 29/04/2026.
//

import UIKit

class HomeCustomCell: UICollectionViewCell {

    @IBOutlet weak var SportName: UILabel!
    @IBOutlet weak var circel: UIView!
    @IBOutlet weak var SportImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        circel.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "Border")?.cgColor
   
    }

}
