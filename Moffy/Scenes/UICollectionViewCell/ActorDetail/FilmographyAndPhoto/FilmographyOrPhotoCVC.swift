//
//  FilmographyOrPhotoCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/03/2024.
//

import UIKit

protocol FilmographyOrPhotoCVCDelegate: AnyObject {
    func filmorOrPhoto(_ switchFilmoOrPhoto: FilmographyOrPhotoCVC.filmographyOrPhoto)
    func showAlert()
}

class FilmographyOrPhotoCVC: BaseCollectionViewCell {
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var filmographyBtn: UIButton!
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    @IBOutlet weak var collectionViewFilmography: UICollectionView!
    
    private var dataPhoto: [ProfilesResponse] = []
    private var dataFilmography: [Result] = []
    
    var switchFilmoOrPhoto: filmographyOrPhoto = .filmography
    weak var delegate: FilmographyOrPhotoCVCDelegate?
    
    enum filmographyOrPhoto {
        case filmography
        case photo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hideCollectionView()
    }
    
    override func setProperties() {
        collectionViewPhoto.delegate = self
        collectionViewPhoto.dataSource = self
        collectionViewFilmography.delegate = self
        collectionViewFilmography.dataSource = self
        collectionViewPhoto.registerNib(ofType: NoSearchCVC.self)
        collectionViewFilmography.registerNib(ofType: NoSearchCVC.self)
    }
    
    func hideCollectionView() {
        collectionViewPhoto.isHidden = true
        collectionViewFilmography.isHidden = false
    }
    
    func setUpCellPhoto(_ dataPhoto: [ProfilesResponse]?) {
        if let newDataPhoto = dataPhoto {
            self.dataPhoto = newDataPhoto
        }
        collectionViewPhoto.reloadData()
    }
    
    func setUpCellFilmography(_ dataFilmography: [Result]?) {
        if let newDataFilmography = dataFilmography {
            self.dataFilmography = newDataFilmography
        }
        collectionViewFilmography.reloadData()
    }
    
    @IBAction func filmographyBtnTapped(_ sender: Any) {
        collectionViewPhoto.isHidden = true
        collectionViewFilmography.isHidden = false
        switchFilmoOrPhoto = .filmography
        delegate?.filmorOrPhoto(switchFilmoOrPhoto)
        filmographyBtn.setBackgroundImage(UIImage(named: "BGButtonPhoto"), for: .normal)
        photoBtn.setBackgroundImage(nil, for: .normal)
    }
    
    @IBAction func photoBtnTapped(_ sender: Any) {
        collectionViewPhoto.isHidden = false
        collectionViewFilmography.isHidden = true
        switchFilmoOrPhoto = .photo
        delegate?.filmorOrPhoto(switchFilmoOrPhoto)
        photoBtn.setBackgroundImage(UIImage(named: "BGButtonPhoto"), for: .normal)
        filmographyBtn.setBackgroundImage(nil, for: .normal)
    }
}

extension FilmographyOrPhotoCVC: UICollectionViewDelegate {
    
}

extension FilmographyOrPhotoCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewPhoto:
            return dataPhoto.count
        case collectionViewFilmography:
            return dataFilmography.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewPhoto:
            let cell = collectionViewPhoto.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
            cell.configPhoto(dataPhoto[indexPath.row])
            return cell
        case collectionViewFilmography:
            let cell = collectionViewFilmography.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
            cell.configFilmography(dataFilmography[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewPhoto:
            break
        case collectionViewFilmography:
            if isNetworkConnected {
                let movie = dataFilmography[indexPath.item]
                if movie.title != nil && movie.name == nil || movie.name == "" {
                    let vc = MovieDetailVC()
                    vc.movieReceiveSeeAllVC = movie.id
                    push(to: vc, animated: true)
                } else {
                    let vc = TVDetailVC()
                    vc.genreIDReceiveTVShowVC = "\(movie.id ?? 0)"
                    push(to: vc, animated: true)
                }
            } else {
                delegate?.showAlert()
            }
        default:
            break
        }
    }
}

extension FilmographyOrPhotoCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 13
        let width = (collectionView.frame.width - a) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
