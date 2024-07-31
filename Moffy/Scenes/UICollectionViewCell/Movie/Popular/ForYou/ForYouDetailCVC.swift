//
//  ForYouDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import UIKit

class ForYouDetailCVC: BaseCollectionViewCell {

    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configDataMovieForYou(_ movie: Result) {
        nameMovieLbl.text = movie.name ?? movie.title
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(movie)
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
    }
}
