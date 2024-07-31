//
//  InformationMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/04/2024.
//

import UIKit
import Cosmos

protocol InformationMovieCVCDelegate: AnyObject {
    func showPopUpAddMovieToPlan()
    func showTrailerWatchNow()
}

class InformationMovieCVC: BaseCollectionViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var watchNowBtn: UIButton!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    
    weak var delegate: InformationMovieCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        watchNowBtn.cornerRadius = watchNowBtn.frame.height / 2
    }
    
    func configDataMovie(_ movie: MovieDetailModel) {
        nameMovieLbl.text = movie.title ?? movie.name
        genreMovieLbl.text = MovieDetailManager.shared.convertMovieDetailIDToGenre(movie)
        ratingView.rating = (movie.voteAverage ?? 0) / 2
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"), placeholderImage: UIImage(named: "DefaultNil"))
        if movie.overview == "" {
            descriptionLbl.isHidden = true
        }
    }
    
    @IBAction func watchNowBtnTapped(_ sender: Any) {
        delegate?.showTrailerWatchNow()
    }
    
    @IBAction func addMovieToPlanBtnTapped(_ sender: Any) {
        delegate?.showPopUpAddMovieToPlan()
    }
}
