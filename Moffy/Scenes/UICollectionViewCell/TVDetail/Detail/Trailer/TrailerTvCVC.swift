//
//  TrailerTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 08/04/2024.
//

import UIKit
import AdMobManager

protocol TrailerTvCVCDelegate: AnyObject {
    func showTrailerPlayVC(for cell: TrailerTvCVC, at indexPath: IndexPath)
}

class TrailerTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var keyThumb: [String]?
    weak var delegate: TrailerTvCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: InTrailerCVC.self)
        collectionView.registerNib(ofType: TrailerNativeAdsCVC.self)
    }
    
    func setUpThumb(_ dataThumb: [String]?) {
        if let newDataThumb = dataThumb {
            self.keyThumb = newDataThumb
        }
        self.collectionView.reloadData()
    }
}

extension TrailerTvCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if AdMobManager.shared.state == .allow {
            return (keyThumb?.count ?? 0) + 1
        } else {
            return keyThumb?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if AdMobManager.shared.state == .allow {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueCell(ofType: InTrailerCVC.self, indexPath: indexPath)
                if let firstTrailer = keyThumb?.first {
                    cell.configDataThumb(firstTrailer)
                }
                return cell
            } else if indexPath.item == 1 {
                let cell = collectionView.dequeueCell(ofType: TrailerNativeAdsCVC.self, indexPath: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueCell(ofType: InTrailerCVC.self, indexPath: indexPath)
                let dataIndex = indexPath.item - 1
                if let keyThumb = keyThumb, dataIndex < keyThumb.count {
                    cell.configDataThumb(keyThumb[dataIndex])
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueCell(ofType: InTrailerCVC.self, indexPath: indexPath)
            cell.configDataThumb(keyThumb?[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showTrailerPlayVC(for: self, at: indexPath)
    }
}

extension TrailerTvCVC: UICollectionViewDelegate {
    
}

extension TrailerTvCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width / 2.33, height: height)
    }
}
