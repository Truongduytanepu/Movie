//
//  SeasonCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 08/04/2024.
//

import UIKit

class SeasonCVC: BaseCollectionViewCell {
    @IBOutlet weak var lineSeasonImage: UIImageView!
    @IBOutlet weak var seasonLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineSeasonImage.isHidden = true
    }
    
    override func prepareForReuse() {
        lineSeasonImage.isHidden = true
        seasonLbl.textColor = UIColor(rgb: 0x727272)
    }
    
    func configSeason(_ eposide: Season?) {
        seasonLbl.text = eposide?.name
    }
    
    func selectedSeason() {
       lineSeasonImage.isHidden = false
       seasonLbl.font = AppFont.get(fontName: .manaropeSemibold, size: 14)
       seasonLbl.textColor = .white
    }
}
