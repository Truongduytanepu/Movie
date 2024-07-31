//
//  UICollectionViewExtension.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    enum Kind {
        case header
        case footer
    }
    
    class func kind(of kind: Kind) -> String {
        switch kind {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
    
    func register(ofType type: AnyClass) {
        self.register(type, forCellWithReuseIdentifier: String(describing: type.self))
    }
    
    func register(ofType type: AnyClass, ofKind kind: Kind) {
        self.register(type, forSupplementaryViewOfKind: UICollectionView.kind(of: kind), withReuseIdentifier: String(describing: type.self))
    }
    
    func registerNib(ofType type: AnyClass, bundle: Bundle = .main) {
        self.register(UINib(nibName: String(describing: type.self), bundle: bundle), forCellWithReuseIdentifier: String(describing: type.self))
    }
    
    func register(ofType type: AnyClass, bundle: Bundle = .main, ofKind kind: Kind) {
        self.register(UINib(nibName: String(describing: type.self), bundle: bundle), forSupplementaryViewOfKind: UICollectionView.kind(of: kind), withReuseIdentifier: String(describing: type.self))
    }
    
    func dequeueCell<T>(ofType type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func dequeueCell<T>(ofType type: T.Type, ofKind kind: Kind, indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.kind(of: kind), withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
