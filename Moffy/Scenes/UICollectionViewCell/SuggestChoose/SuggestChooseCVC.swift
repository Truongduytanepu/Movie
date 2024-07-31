//
//  SuggestChooseCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/02/2024.
//

import UIKit
import SDWebImage

class SuggestChooseCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var bgBottom: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var borderCell: UIImageView!
    @IBOutlet weak var imageMovie: UIImageView!
    
    private var genreText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.isHidden = true
        borderCell.isHidden = true
        checkCornerRadius()
    }
    
    func checkCornerRadius() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            imageMovie.layer.cornerRadius = 20
        } else {
            imageMovie.layer.cornerRadius = 26
        }
    }
    func configTitle(_ movie: Result) {
        genreText = ""
        name.text = movie.title ?? movie.name
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"), 
                               placeholderImage: UIImage(named: "DefaultNil"))
        
        genres.text = MovieGenreManager.shared.convertIDToGenre(movie)
        if MovieTopRateManager.shared.cacheCoverPlan1 == movie.posterPath {
            selectedCell()
        } else {
            removeSelectedCell()
        }
        
    }
    
    func configTitleTvShow(_ movie: Result) {
        genreText = ""
        name.text = movie.name ?? movie.title
        imageMovie.sd_setImage(with: URL(string: URLs.domainImage + "\(movie.posterPath ?? "")"), 
                               placeholderImage: UIImage(named: "DefaultNil"))
        
        genres.text = MovieGenreManager.shared.convertIDToGenre(movie)
    }
    
    func selectedCell() {
        checkBox.isHidden = false
        borderCell.isHidden = false
    }
    
    func removeSelectedCell() {
        checkBox.isHidden = true
        borderCell.isHidden = true
    }
}
