//
//  UICollectionViewCellExtension.swift
//  MovieIOS7
//
//  Created by Trịnh Xuân Minh on 13/03/2022.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func getIndexPath() -> IndexPath? {
        guard let collectionView = self.nearestAncestor(ofType: UICollectionView.self) else {
            return nil
        }
        return collectionView.indexPath(for: self)
    }
    
    func showAlert(title: String, message: String, from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
