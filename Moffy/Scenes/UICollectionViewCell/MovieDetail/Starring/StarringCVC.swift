//
//  StarringCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/04/2024.
//

import UIKit

protocol StarringCVCDelegate: AnyObject {
    func showStarringDetail(for cell: StarringCVC, at indexPath: IndexPath)
}

class StarringCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataStarring: [Result]?
    weak var delegate: StarringCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: InStarringCVC.self)
    }
    
    func setUpCell(_ starring: [Result]?) {
        if let newStarring = starring {
            self.dataStarring = newStarring
        }
        self.collectionView.reloadData()
    }
}

extension StarringCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStarring?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: InStarringCVC.self, indexPath: indexPath)
        cell.configDataSrtarring(dataStarring?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showStarringDetail(for: self, at: indexPath)
    }
}

extension StarringCVC: UICollectionViewDelegate {
    
}

extension StarringCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 1.5, height: collectionView.frame.height)
    }
}
