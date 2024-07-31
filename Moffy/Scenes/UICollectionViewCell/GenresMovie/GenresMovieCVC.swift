//
//  GenresMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit

class GenresMovieCVC: BaseCollectionViewCell {
    @IBOutlet weak var genresBGImage: UIImageView!
    @IBOutlet weak var genresLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(_ movieGenre: MovieGenre) {
        DispatchQueue.main.async {
            self.genresLbl.text = movieGenre.name
        }
    }
    
    func configTVGenres(_ tvGenres: MovieGenre) {
        DispatchQueue.main.async {
            self.genresLbl.text = tvGenres.name
        }
    }

}
