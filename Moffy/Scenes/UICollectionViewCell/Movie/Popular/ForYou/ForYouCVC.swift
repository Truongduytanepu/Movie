//
//  ForYouCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import UIKit
import AdMobManager

protocol ForYouCVCDelegate: AnyObject {
    func seeMoreForYou()
    func showArlert()
    func showForYouDetail(at indexPath: IndexPath)
}

class ForYouCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var vcReceiveMovieVC: UIViewController?
    weak var delegate: ForYouCVCDelegate?
    var dataMovies: [Result] = []
    var chooseMovieOrTVReceiMovieVC = MovieVC().chooseMovieOrTvShow
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: ForYouDetailCVC.self)
    }

    func setUpCell(_ dataMovies: [Result]?, vc: UIViewController?) {
        if let newDataMovie = dataMovies {
            self.dataMovies = newDataMovie
            self.vcReceiveMovieVC = vc
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func seeMoreBtnTapped(_ sender: Any) {
        delegate?.seeMoreForYou()
    }
}

extension ForYouCVC: UICollectionViewDelegate {
    
}

extension ForYouCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, dataMovies.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ForYouDetailCVC.self, indexPath: indexPath)
        cell.configDataMovieForYou(dataMovies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showForYouDetail(at: indexPath)
        } else {
            delegate?.showArlert()
        }
    }
}

extension ForYouCVC: UICollectionViewDelegateFlowLayout {
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
