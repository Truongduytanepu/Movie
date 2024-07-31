//
//  FavoriteTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/04/2024.
//

import UIKit

protocol FavoriteTvCVCDelegate: AnyObject {
    func removeTVFavorite(at indexPath: IndexPath?)
}

class FavoriteTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var nameMovieLbl: UILabel!
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    private var genreText = ""
    weak var delegate: FavoriteTvCVCDelegate?
    var indexPathReceiveFavoriteVC: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func configTitle(_ movie: MovieDetailObject) {
        genreText = ""
        nameMovieLbl.text = movie.title ?? movie.name
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        genreMovieLbl.isHidden = false
        genreMovieLbl.text = MovieGenreManager.shared.convertIDMovieToGenre(Array(movie.genreIds))
    }
    
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        delegate?.removeTVFavorite(at: indexPathReceiveFavoriteVC)
    }
}
