//
//  SplashVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 04/03/2024.
//

import UIKit
import AdMobManager

class SplashVC: BaseViewController {
    private let suggestChooseVC = SuggestChooseVC()
    private let tabbarVC = TabBarVC()
    private let suggestVC = SuggestVC()
    
    override func binding() {
        AdMobManager.shared.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else {
                    return
                }
                if state == .allow {
                    AdMobManager.shared.load(type: .splash, name: "ID_Intern_Splash")
                    AdMobManager.shared.load(type: .appOpen, name: "ID_Open_app")
                    AdMobManager.shared.load(type: .interstitial, name: "AllLayout_Inter")
                    AdMobManager.shared.load(type: .interstitial, name: "Interstitial")
                    AdMobManager.shared.load(type: .interstitial, name: "Search_Inter")
                    AdMobManager.shared.preloadNative(name: "SeeAll_Native")
                    AdMobManager.shared.preloadNative(name: "DetailMovie_Native")
                }
                
                if state != .unknow {
                    AdMobManager.shared.show(type: .splash,
                                             name: "ID_Intern_Splash",
                                             rootViewController: self,
                                             didFail: self.onBoardShow,
                                             didHide: self.onBoardShow)
                }
            }.store(in: &subscriptions)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    private func onBoardShow() {
        DispatchQueue.main.async {
            if RealmService.shared.fetch(ofType: PlanObject.self).count > 0 {
                self.push(to: self.tabbarVC, animated: true)
            } else if MovieGenreManager.shared.getMovieGenres().count > 0 && TVGenresManager.shared.getTVGenres().count > 0 {
                self.push(to: self.suggestChooseVC, animated: true)
            } else {
                self.push(to: self.suggestVC, animated: true)
            }
        }
    }
}
