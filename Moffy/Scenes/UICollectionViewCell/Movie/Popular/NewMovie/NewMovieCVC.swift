//
//  NewMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import AdMobManager

protocol NewMovieCVCDelegate: AnyObject {
    func seeAllNewMovie()
    func showArlert()
    func showNewMovieDetail(at indexPath: IndexPath)
}

class NewMovieCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataMovies: [Result] = []
    private var vcReceiveMovieVC: UIViewController?
    weak var delegate: NewMovieCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: NewMovieDetailCVC.self)
    }
    
    func setUpCell(_ dataMovie: [Result]?, vc: UIViewController?) {
        if let newDataMovie = dataMovie {
            self.dataMovies = newDataMovie
            self.vcReceiveMovieVC = vc
        }
        collectionView.reloadData()
    }
    
    @IBAction func seeAllNewMovieBtnTapped(_ sender: Any) {
        delegate?.seeAllNewMovie()
    }
}

extension NewMovieCVC: UICollectionViewDelegate {
    
}

extension NewMovieCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, dataMovies.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NewMovieDetailCVC.self, indexPath: indexPath)
        cell.configData(dataMovies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showNewMovieDetail(at: indexPath)
        } else {
            delegate?.showArlert()
        }
    }
}

extension NewMovieCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 6.5 - 16, height: collectionView.frame.height / 2 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
