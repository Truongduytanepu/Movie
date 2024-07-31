//
//  NewMovieDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit

class NewMovieDetailCVC: BaseCollectionViewCell {

    @IBOutlet weak var genresMovieLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(_ movie: Result) {
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"), 
                               placeholderImage: UIImage(named: "DefaultNil"))
        nameMovieLbl.text = movie.name ?? movie.title
        genresMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(movie)
    }
}
