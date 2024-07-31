//
//  TrailerNativeAdsCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 27/04/2024.
//

import UIKit
import AdMobManager

class TrailerNativeAdsCVC: BaseCollectionViewCell {
    @IBOutlet weak var nativeAdsView: CustomNativeAdSize9View!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if AdMobManager.shared.state == .allow {
//            addAds(name: "DetailMovie_Native")
//        }
    }
    
    override func setProperties() {
       
    }
    
//    private func addAds(name: String) {
//        if AdMobManager.shared.status(type: .onceUsed(.native), name: name) == true {
//            nativeAdsView.setupAds(name: name, didError: { [weak self] in
//                guard let self = self else { return }
//                self.nativeAdsView.isHidden = true
//            })
//        } else {
//            nativeAdsView.isHidden = true
//        }
//    }
}
