//
//  SuggestVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/02/2024.
//

import UIKit
import SnapKit
import Combine

class SuggestVC: BaseViewController {
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tutorialText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Screen {
        case screen1
        case screen2
    }
    
    private var currentScreen: Screen = .screen1
    private var buttonTapCount = 0
    private var contentShowPopup = "Maximum 5 selected genres"
    private var selectedIndexPathMovie: [IndexPath] = []
    private var selectedIndexPathTV: [IndexPath] = []
    private lazy var imageBG: UIImageView = {
        let imageBG = UIImageView(image: UIImage(named: "ImageBG"))
        return imageBG
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieGenreManager.shared.fetch()
        TVGenresManager.shared.fetch()
        switchScreen()
        checkCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func addComponents() {
        view.addSubview(imageBG)
    }
    
    override func binding() {
        super.binding()
        MovieGenreManager.shared.$movieGenre
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        TVGenresManager.shared.$tvGenre
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    override func setConstraints() {
        imageBG.snp.makeConstraints { make in
            make.width.height.equalTo(206.41)
            make.top.equalTo(-7.34)
            make.centerX.equalTo(view)
        }
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: SuggestCVC.self)
        tutorialText.isHidden = true
        nextBtn.layer.cornerRadius = 24
    }
    
    private func switchScreen() {
        switch currentScreen {
        case .screen1:
            titleLbl.text = "Pick your preferred movie type"
        case .screen2:
            titleLbl.text = "Pick your preferred TV Show type"
        }
    }
    
    private func defaultButton() {
        tutorialText.isHidden = true
        nextBtn.borderColor = UIColor(rgb: 0x7CDD9)
        nextBtn.borderWidth = 1
        nextBtn.layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    private func checkCount() {
        switch currentScreen {
        case .screen1:
            if MovieGenreManager.shared.getMovieGenres().count == 5 {
                gradiant(button: nextBtn)
                tutorialText.isHidden = false
            }else {
                defaultButton()
            }
        case .screen2:
            if TVGenresManager.shared.getTVGenres().count == 5 {
                gradiant(button: nextBtn)
                tutorialText.isHidden = false
            } else {
                defaultButton()
            }
        }
    }
    
    @IBAction func pushSearch(_ sender: Any) {
        let searchVC = SearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        switch buttonTapCount {
        case 0: // Lần đầu tiên nhấn Next
            if MovieGenreManager.shared.getMovieGenres().count == 5 {
                buttonTapCount += 1
                currentScreen = .screen2
                switchScreen()
                pageLbl.text = "2/2"
                tutorialText.isHidden = true
                checkCount()
                collectionView.reloadData()
            }
        case 1: // Lần thứ hai nhấn Next
            if TVGenresManager.shared.getTVGenres().count == 5 {
                let suggestChooseVC = SuggestChooseVC()
                push(to: suggestChooseVC, animated: true)
            }
        default:
            break
        }
    }
}

extension SuggestVC: UICollectionViewDelegate{
    
}

extension SuggestVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentScreen == .screen1 {
            return MovieGenreManager.shared.movieGenre.count
        } else {
            return TVGenresManager.shared.tvGenre.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SuggestCVC.self, indexPath: indexPath)
        
        switch currentScreen {
        case .screen1:
            let genre = MovieGenreManager.shared.movieGenre[indexPath.row]
            cell.config(genre)
            
            if MovieGenreManager.shared.getMovieGenres().first(where: { $0.id == genre.id }) != nil {
                cell.imageCell.image = UIImage(named: "ButtonCellTap")
            } else {
                cell.imageCell.image = UIImage(named: "SuggestCell")
            }
        case .screen2:
            let genre = TVGenresManager.shared.tvGenre[indexPath.row]
            cell.config(genre)
            
            if TVGenresManager.shared.getTVGenres().first(where: { $0.id == genre.id }) != nil {
                cell.imageCell.image = UIImage(named: "ButtonCellTap")
            } else {
                cell.imageCell.image = UIImage(named: "SuggestCell")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentScreen {
        case .screen1:
            let movie = MovieGenreManager.shared.movieGenre[indexPath.row]
            let movieGenreObject = MovieGenreObject(with: movie)
            
            if MovieGenreManager.shared.getMovieGenres().count < 5 {
                MovieGenreManager.shared.saveMovieSelected(with: movieGenreObject)
                
                collectionView.reloadItems(at: [indexPath])
            } else if let existingMovie = MovieGenreManager.shared.getMovieGenres().first(where: {$0.id == movie.id})  {
                MovieGenreManager.shared.removeMovieExisting(with: existingMovie)
                defaultButton()
                collectionView.reloadItems(at: [indexPath])
            } else {
                showPopUp(content: contentShowPopup)
            }
            
            if MovieGenreManager.shared.getMovieGenres().count == 5 {
                tutorialText.isHidden = false
                nextBtn.borderColor = .clear
                gradiant(button: nextBtn)
            }
        case .screen2:
            let tv = TVGenresManager.shared.tvGenre[indexPath.row]
            let tvObject = TVGenreObject(with: tv)
            
            if TVGenresManager.shared.getTVGenres().count < 5 {
                TVGenresManager.shared.saveTVSelected(with: tvObject)
                collectionView.reloadItems(at: [indexPath])
            } else if let existingTV = TVGenresManager.shared.getTVGenres().first(where: {$0.id == tv.id}) {
                TVGenresManager.shared.removeTVExisting(with: existingTV)
                defaultButton()
                collectionView.reloadItems(at: [indexPath])
            } else {
                showPopUp(content: contentShowPopup)
            }
            
            if TVGenresManager.shared.getTVGenres().count == 5 {
                tutorialText.isHidden = false
                nextBtn.borderColor = .clear
                gradiant(button: nextBtn)
            }
        }
    }
}

extension SuggestVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 42 * 2 + 8
        let width = (collectionView.frame.width - a) / 2
        return CGSize(width: width, height: width / 3)
    }
}
