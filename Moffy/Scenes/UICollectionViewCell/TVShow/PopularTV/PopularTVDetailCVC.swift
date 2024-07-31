//
//  PopularTVDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/04/2024.
//

import UIKit
import Cosmos
import FSPagerView

class PopularTVDetailCVC: FSPagerViewCell {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var genresAndYearLbl: UILabel!
    @IBOutlet weak var nameMovieLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.removeShadowPagerView()
    }
    
    private func removeShadowPagerView() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.layer.shadowColor = UIColor.clear.cgColor
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        self.contentView.layer.shadowOffset = .zero
    }
    
    func configDataMovies(_ tv: Result) {
        let genre = MovieGenreManager.shared.convertIDToGenre(tv)
        let dateString = "\(tv.firstAirDate ?? "1994-03-03")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            genresAndYearLbl.text = "\(genre) • \(year)"
        } else {
            print("Invalid date format")
        }
        nameMovieLbl.text = tv.title ?? tv.name
        if let posterPath = tv.posterPath, !posterPath.isEmpty{
            imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(posterPath)"))
        } else if tv.posterPath == nil {
            imageMovie.image = UIImage(named: "DefaultNil")
        }
        ratingView.rating = ((tv.voteAverage ?? 0) / 2)
    }
}
