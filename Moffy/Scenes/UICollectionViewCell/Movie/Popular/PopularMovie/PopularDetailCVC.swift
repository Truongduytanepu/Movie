//
//  PopularDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import FSPagerView
import Cosmos

class PopularDetailCVC: FSPagerViewCell {
    
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
    
    func configDataMovies(_ movie: Result) {
        let genre = MovieGenreManager.shared.convertIDToGenre(movie)
        let dateString = "\(movie.releaseDate ?? "1994-03-03")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            genresAndYearLbl.text = "\(genre) • \(year)"
        } else {
            print("Invalid date format")
        }
        nameMovieLbl.text = movie.title ?? movie.name
        if let posterPath = movie.posterPath, !posterPath.isEmpty{
            imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(posterPath)"))
        } else if movie.posterPath == nil {
            imageMovie.image = UIImage(named: "DefaultNil")
        }
        ratingView.rating = ((movie.voteAverage ?? 0) / 2)
    }
}
