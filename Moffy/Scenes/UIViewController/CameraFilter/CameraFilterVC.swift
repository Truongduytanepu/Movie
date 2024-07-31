//
//  CameraFilterVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/04/2024.
//

import UIKit

enum FilterImage: String, CaseIterable {
    case frame1
    case frame2
    case frame3
    case frame4
    case frame5
}

class CameraFilterVC: BaseViewController {
    @IBOutlet weak var imageFilter: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedIndex: Int?
    var selectedIndexPath: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: CameraFilterCVC.self)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        selectedIndexPath?(self.selectedIndex ?? 0)
        pop(animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}

extension CameraFilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FilterImage.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: CameraFilterCVC.self, indexPath: indexPath)
        let filter = FilterImage.allCases[indexPath.item]
        if let image = UIImage(named: filter.rawValue) {
            cell.filterImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = FilterImage.allCases[indexPath.item]
        if let image = UIImage(named: filter.rawValue) {
            imageFilter.image = image
        }
        self.selectedIndex = indexPath.item
        print(selectedIndex)
    }
}

extension CameraFilterVC: UICollectionViewDelegate {
    
}

extension CameraFilterVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        return CGSize(width: width / 2.84, height: height)
    }
}
