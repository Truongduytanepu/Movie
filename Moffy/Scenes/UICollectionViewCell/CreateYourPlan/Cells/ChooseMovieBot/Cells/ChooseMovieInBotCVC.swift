//
//  ChooseMovieInBotCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 05/03/2024.
//

import UIKit
import RealmSwift

protocol ChooseMovieInBotCVCDelegate: AnyObject {
    func didRemoveMovie(_ movie: MovieObject)
    
    func didRemoveMovdeFormDetail(_ movie: MovieObject)
    
    func didRemoveMovdeFormDetail1(_ movie: MovieObject)
    
    func editPlan(for cell: ChooseMovieInBotCVC)
    
}

class ChooseMovieInBotCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var imageDone: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var genreAndYearLbl: UILabel!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    
    enum ScreenChooseMovie {
        case movieCreate
        case yourMovie
        case detailPlan
    }
    
    var screenChooseMovie: ScreenChooseMovie = .movieCreate
    var movieIndex: Int?
    var movie: MovieObject?
    var plan: PlanObject?
    var delegate: SuggestPlanInBotCVCDelegate?
    var movies: [MovieObject] = []
    var chooseDelegate: ChooseMovieInBotCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideCheckDoneImage()
    }
    
    
    func configMovie(_ movie: MovieObject) {
        self.movie = movie
        let genre = MovieGenreManager.shared.convertIDMovieObjectToGenre(movie)
        let dateString = "\(movie.releaseDate ?? "1994-03-03")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            genreAndYearLbl.text = "\(genre) • \(year)"
        } else {
            genreAndYearLbl.text = "\(genre)"
        }
        timeLbl.text = "1h30m"
    
        if movie.name != nil && movie.title == nil || movie.title == ""{
            movieNameLbl.text = movie.name
        }
        
        if movie.title != nil && movie.name == nil || movie.name == ""{
            movieNameLbl.text = movie.title
        }
        
        if movie.isDone {
            imageDone.isHidden = false
        } else {
            imageDone.isHidden = true
        }
        
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
    }
    
    func hideCheckDoneImage() {
        if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
            screenChooseMovie = .movieCreate
            imageDone.isHidden = true
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
            screenChooseMovie = .yourMovie
            imageDone.isHidden = true
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
            screenChooseMovie = .detailPlan
        }
    }
    
    
    @IBAction func deleteMovieTapped(_ sender: Any) {
        guard let movieName = movieNameLbl.text else {
            return
        }
        if MovieTopRateManager.shared.checkEditOrCreatePlan == 0 {
            screenChooseMovie = .movieCreate
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 1 {
            screenChooseMovie = .yourMovie
        } else if MovieTopRateManager.shared.checkEditOrCreatePlan == 2 {
            screenChooseMovie = .detailPlan
        }
        
        switch screenChooseMovie {
        case .movieCreate:
            MovieTopRateManager.shared.movieDefaultRealm.removeAll(where: {$0.name == movieName || $0.title == movieName})
            MovieTopRateManager.shared.movieChooseArray = MovieTopRateManager.shared.movieDefaultRealm
            NotificationCenter.default.post(name: Notification.Name("DidRemoveMovie"), object: nil)
        case .yourMovie:
            MovieTopRateManager.shared.movieDefaultRealm.removeAll(where: {$0.name == movieName || $0.title == movieName})
            MovieTopRateManager.shared.movieChooseArray = MovieTopRateManager.shared.movieDefaultRealm
            
            guard let movie = self.movie else {
                return
            }
            
            self.chooseDelegate?.didRemoveMovie(movie)
            
        case .detailPlan:
            guard let movie = self.movie else {
                return
            }
            self.chooseDelegate?.didRemoveMovdeFormDetail1(movie)
        }
    }
}
