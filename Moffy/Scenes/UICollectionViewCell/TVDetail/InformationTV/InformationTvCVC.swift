//
//  InformationTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit
import Cosmos

protocol InformationTvCVCDelegate: AnyObject {
    func showPopUpAddTVToPlan()
    func showTrailerPlayVC()
}

class InformationTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var watchNowBtn: UIButton!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    
    weak var delegate: InformationTvCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        watchNowBtn.cornerRadius = watchNowBtn.frame.height / 2
    }
    
    func configDataTV(_ tv: MovieDetailModel) {
        nameMovieLbl.text = tv.title ?? tv.name
        genreMovieLbl.text = MovieDetailManager.shared.convertMovieDetailIDToGenre(tv)
        ratingView.rating = (tv.voteAverage ?? 0) / 2
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(tv.posterPath ?? "")"), placeholderImage: UIImage(named: "DefaultNil"))
    }
    
    @IBAction func addMovieToPlanBtnTapped(_ sender: Any) {
        delegate?.showPopUpAddTVToPlan()
    }
    
    @IBAction func watchNowBtnTapped(_ sender: Any) {
        delegate?.showTrailerPlayVC()
    }
}
