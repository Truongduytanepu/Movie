//
//  SimilarMoviesCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/04/2024.
//

import UIKit

protocol SimilarMoviesCVCDelegate: AnyObject {
    func seeMoreSimilar()
    func showMovieDetail(for cell: SimilarMoviesCVC, at indexPath: IndexPath)
}

class SimilarMoviesCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SimilarMoviesCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var dataSimilar: [Result]?
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: NoSearchCVC.self)
    }
    
    func setUpDataSimilar(_ similar: [Result]?) {
        if let newDataSimilar = similar {
            self.dataSimilar = newDataSimilar
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func seeMoreSimilarBtnTapped(_ sender: Any) {
        delegate?.seeMoreSimilar()
    }
}

extension SimilarMoviesCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(6, dataSimilar?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: NoSearchCVC.self, indexPath: indexPath)
        cell.configSimilar(dataSimilar?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showMovieDetail(for: self, at: indexPath)
    }
}

extension SimilarMoviesCVC: UICollectionViewDelegate {
    
}

extension SimilarMoviesCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a: CGFloat = 13
        let width = (collectionView.frame.width - a - 16 * 2) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}

