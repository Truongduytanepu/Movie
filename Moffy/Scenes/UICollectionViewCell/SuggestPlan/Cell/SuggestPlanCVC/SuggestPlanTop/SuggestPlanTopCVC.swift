//
//  SuggestPlanTopCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/02/2024.
//

import UIKit

class SuggestPlanTopCVC: BaseCollectionViewCell {
    @IBOutlet weak var imageProgress: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataTopPlan: [PlanSuggestObject]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func binding() {
        PlanManager.shared.$planObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.estimatedItemSize = .zero
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.registerNib(ofType: SuggestPlanInTopCVC.self)
    }
    
    func setUpCell(dataTopPlan: [PlanSuggestObject]?) {
        self.dataTopPlan = dataTopPlan
        collectionView.reloadData()
    }
}

extension SuggestPlanTopCVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        RealmService.shared.fetch(ofType: PlanSuggestObject.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SuggestPlanInTopCVC.self, indexPath: indexPath)
        if let data = dataTopPlan {
            cell.plan = data[indexPath.item]
            cell.configData(data[indexPath.item])
        }
        return cell
    }
}

extension SuggestPlanTopCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
}

extension SuggestPlanTopCVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        if collectionView == self.collectionView {
            // Lấy vị trí hiện tại của contentOffset
            let contentOffsetX = collectionView.contentOffset.x
            
            // Tính toán khoảng cách từ vị trí hiện tại đến vị trí của cell kế tiếp
            let cellWidth = collectionView.frame.width
            let nextCellOffsetX = contentOffsetX + cellWidth - 36.5
            
            // Lấy index của cell kế tiếp
            let nextCellIndex = Int(nextCellOffsetX / cellWidth)
            
            // Xử lý dựa trên index của cell kế tiếp
            switch nextCellIndex {
            case 1:
                UIView.transition(with: imageProgress, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.imageProgress.image = UIImage(named: "Progress2")
                }, completion: nil)
            case 2:
                UIView.transition(with: imageProgress, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.imageProgress.image = UIImage(named: "Progress3")
                }, completion: nil)
            case 0:
                UIView.transition(with: imageProgress, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.imageProgress.image = UIImage(named: "Progress1")
                }, completion: nil)
            default:
                break
            }
        }
    }
}
