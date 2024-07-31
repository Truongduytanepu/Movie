//
//  ForYouCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import UIKit
import AdMobManager

protocol ForYouTvCVCDelegate: AnyObject {
    func seeMoreForYou()
    func showAlert()
    func showForYouDetail(at indexPath: IndexPath)
}

class ForYouTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var vcReceiveTvVC: UIViewController?
    weak var delegate: ForYouTvCVCDelegate?
    var dataTVs: [Result] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: ForYouTVDetailCVC.self)
    }
    
    func setUpCell(_ dataTVs: [Result]?, vc: UIViewController?) {
        if let newDataTVs = dataTVs {
            self.dataTVs = newDataTVs
            self.vcReceiveTvVC = vc
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func seeMoreBtnTapped(_ sender: Any) {
        delegate?.seeMoreForYou()
    }
}

extension ForYouTvCVC: UICollectionViewDelegate {
    
}

extension ForYouTvCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, dataTVs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ForYouTVDetailCVC.self, indexPath: indexPath)
        cell.configDataMovieForYou(dataTVs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showForYouDetail(at: indexPath)
        } else {
            delegate?.showAlert()
        }
    }
}

extension ForYouTvCVC: UICollectionViewDelegateFlowLayout {
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
