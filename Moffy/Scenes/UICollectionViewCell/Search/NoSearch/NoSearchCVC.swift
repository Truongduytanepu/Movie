//
//  NoSearchCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/02/2024.
//

import UIKit

class NoSearchCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var nameMovieLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var bgBottom: UIImageView!
    
    private var genreText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configTitle(_ movie: Result) {
        genreText = ""
        nameMovieLbl.text = movie.title
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        genreMovieLbl.isHidden = false
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(movie)
    }
    
    func configTitleTvShow(_ tv: Result) {
        genreText = ""
        nameMovieLbl.text = tv.name ?? tv.title
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(tv.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        genreMovieLbl.isHidden = false
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(tv)
    }
    
    func configActor(_ actor: Result) {
        nameMovieLbl.text = actor.name
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(actor.profilePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        genreMovieLbl.isHidden = true
    }
    
    func configFilmography(_ graphy: Result) {
        nameMovieLbl.text = graphy.title
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(graphy.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(graphy)
    }
    
    func configPhoto(_ photo: ProfilesResponse) {
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(photo.filePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        nameMovieLbl.isHidden = true
        genreMovieLbl.isHidden = true
        bgBottom.isHidden = true
    }
    
    func configSimilar(_ similar: Result?) {
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(similar?.posterPath ?? "")"), placeholderImage: UIImage(named: "DefaultNil"))
        nameMovieLbl.text = similar?.title ?? similar?.name
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(similar ?? Result())
    }
}
