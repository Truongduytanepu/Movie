
//
//  NewMovieDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit

class NewTVDetailCVC: BaseCollectionViewCell {

    @IBOutlet weak var genresTVLbl: UILabel!
    @IBOutlet weak var nameTVLbl: UILabel!
    @IBOutlet weak var imageTV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configData(_ tv: Result) {
        imageTV.sd_setImage(with: URL(string: URLs.domainImage + "\(tv.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        nameTVLbl.text = tv.name
        genresTVLbl.text = MovieGenreManager.shared.convertIDToGenre(tv)
    }
}
