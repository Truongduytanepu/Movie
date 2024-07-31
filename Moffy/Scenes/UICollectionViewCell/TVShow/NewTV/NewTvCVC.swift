//
//  NewMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 20/03/2024.
//

import UIKit
import AdMobManager

protocol NewTvCVCDelegate: AnyObject {
    func seeAllNewTV()
    func showAlert()
    func showNewTVDetail(at indexPath: IndexPath)
}

class NewTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataTVs: [Result] = []
    private var vcReceiveTvVC: UIViewController?
    weak var delegate: NewTvCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: NewTVDetailCVC.self)
    }
    
    func setUpCell(_ dataTVs: [Result]?, vc: UIViewController?) {
        if let newDataTV = dataTVs {
            self.dataTVs = newDataTV
            self.vcReceiveTvVC = vc
        }
        collectionView.reloadData()
    }
    
    @IBAction func seeAllNewTVBtnTapped(_ sender: Any) {
        delegate?.seeAllNewTV()
    }
}

extension NewTvCVC: UICollectionViewDelegate {
    
}

extension NewTvCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, dataTVs.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NewTVDetailCVC.self, indexPath: indexPath)
        cell.configData(dataTVs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showNewTVDetail(at: indexPath)
        } else {
            delegate?.showAlert()
        }
    }
}

extension NewTvCVC: UICollectionViewDelegateFlowLayout {
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
