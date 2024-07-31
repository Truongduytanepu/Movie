//
//  GenresTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit

class GenresTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var genresBGImage: UIImageView!
    @IBOutlet weak var genresLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configTVGenres(_ tvGenres: MovieGenre) {
        DispatchQueue.main.async {
            self.genresLbl.text = tvGenres.name
        }
    }

}
