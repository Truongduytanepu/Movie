//
//  ForYouTVDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit

class ForYouTVDetailCVC: BaseCollectionViewCell {
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configDataMovieForYou(_ tv: Result) {
        nameMovieLbl.text = tv.name ?? tv.title
        genreMovieLbl.text = MovieGenreManager.shared.convertIDToGenre(tv)
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(tv.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
    }
}
