//
//  ActorTvCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 08/04/2024.
//

import UIKit

protocol ActorTvCVCDelegate: AnyObject {
    func showStarringDetail(for cell: ActorTvCVC, at indexPath: IndexPath)
}

class ActorTvCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataStarring: [Result]?
    weak var delegate: ActorTvCVCDelegate?
    
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

extension ActorTvCVC: UICollectionViewDataSource {
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

extension ActorTvCVC: UICollectionViewDelegate {
    
}

extension ActorTvCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 1.5, height: collectionView.frame.height)
    }
}
