//
//  PopularPeopleCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import UIKit

protocol PopularPeopleCVCDelegate: AnyObject {
    func seeAllPopularPeople()
    func showArlert()
    func showActorDetail(at indexPath: IndexPath)
}

class PopularPeopleCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var actorData: [Result] = []
    weak var delegate: PopularPeopleCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: PopularPeopleDetailCVC.self)
    }
    
    func setUpCell(_ actorData: [Result]?) {
        if let newActorData = actorData {
            self.actorData = newActorData
        }
        collectionView.reloadData()
    }
    @IBAction func seeAllPopularPeopleBtnTapped(_ sender: Any) {
        delegate?.seeAllPopularPeople()
    }
}

extension PopularPeopleCVC: UICollectionViewDelegate {
    
}

extension PopularPeopleCVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: PopularPeopleDetailCVC.self, indexPath: indexPath)
        cell.configData(actorData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showActorDetail(at: indexPath)
        } else {
            delegate?.showArlert()
        }
    }
}

extension PopularPeopleCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90 , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
