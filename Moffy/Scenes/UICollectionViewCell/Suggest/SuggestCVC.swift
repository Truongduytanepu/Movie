//
//  SuggestCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/02/2024.
//

import UIKit

class SuggestCVC: BaseCollectionViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func config(_ movieGenre: MovieGenre) {
        DispatchQueue.main.async {
            self.nameLbl.text = movieGenre.name
            self.view?.layer.cornerRadius = 15
        }
    }
    
    func configTVGenres(_ tvGenres: MovieGenre) {
        DispatchQueue.main.async {
            self.nameLbl.text = tvGenres.name
            self.view?.layer.cornerRadius = 15
        }
    }
}
