//
//  Global.swift
//  Moffy
//
//  Created by Trương Duy Tân on 23/04/2024.
//
//
//import UIKit
//import Combine
//import AdMobManager
//
//class Global {
//    static let shared = Global()
//    private(set) var isShowAds: Bool = false
//    enum Keys {
//        // Local
//        static let didShowWelcome = "DID_SHOW_WELCOME"
//        static let openAppCount = "OPEN_APP_COUNT"
//        static let didShowShowInformation = "DID_SHOW_INFORMATION"
//        // Feedback
//        static let email = "EMAIL"
//        // Credit
//        static let defaultFree = "DEFAULT_FREE"
//        static let rewardFree = "REWARD_FREE"
//        static let maxRemainingFree = "MAX_REMAINING_FREE"
//        // IAA
//        static let adMobConfig = "ADMOB_V1_0"
//        // Push Rate
//        static let pushRateConfig = "PUSH_RATE_V1_0"
//        static let rateInApp = "RATE_IN_APP"
//        // Push Update
//        static let pushUpdateConfig = "PUSH_UPDATE_V1_0"
//        // Push Tracking
//        static let pushTrackingConfig = "PUSH_TRACKING_V1_0"
//    }
//
//    // Local
//    private(set) var loadRemoteConfigState = false
//    private(set) var allowShowAppOpen = false
//    private(set) var allowShowWelcome = false
//    private(set) var allowShowInformation = false
//    private(set) var openAppCount = 0
//    // Feedback
//    private(set) var email: String?
//    // Credit
//    private(set) var defaultFree = 3
//    private(set) var rewardFree = 3
//    private(set) var maxRemainingFree = 10
//}
//
//extension Global {
//    func fetch() {
//        fetchWelcome()
//        fetchInformation()
//
//        openApp()
//        registerAdMob()
//    }
//
//    func setShowAppOpen(allow: Bool) {
//        self.allowShowAppOpen = allow
//    }
//
//    func didShowWelcome() {
//        UserDefaults.standard.set(true, forKey: Keys.didShowWelcome)
//        fetchWelcome()
//    }
//
//}
//
//extension Global {
//
//    private func registerAdMob() {
//        //      AdMobManager.shared.load(type: .appOpen, name: AppText.AdName.openApp)
//        //      AdMobManager.shared.load(type: .splash, name: AppText.AdName.internSplash)
//        //      AdMobManager.shared.load(type: .rewarded, name: AppText.AdName.rewardsCamera)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeTrending)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialEmpty)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeClickVideo)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialPreview)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeTrendingDetail)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialCameraBack)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interRetake)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interTrendingBack)
//        //      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interCameraTrending)
//        //      AdMobManager.shared.preloadNative(name: AppText.AdName.nativeOnboard)
//        //      AdMobManager.shared.preloadNative(name: AppText.AdName.nativeLanguage)
//
//        if let url = Bundle.main.url(forResource: "AdMobDefaultValue", withExtension: "json"),
//           let data = try? Data(contentsOf: url) {
//            AdMobManager.shared.register(defaultData: data)
//        }
//    }
//
//    private func didShowInformation() {
//        UserDefaults.standard.set(true, forKey: Keys.didShowShowInformation)
//        fetchInformation()
//    }
//
//    private func fetchWelcome() {
//        self.allowShowWelcome = !UserDefaults.standard.bool(forKey: Keys.didShowWelcome)
//    }
//
//    private func fetchInformation() {
//        self.allowShowInformation = !UserDefaults.standard.bool(forKey: Keys.didShowShowInformation)
//    }
//
//    private func openApp() {
//        self.openAppCount = UserDefaults.standard.integer(forKey: Keys.openAppCount)
//        self.openAppCount += 1
//        UserDefaults.standard.set(openAppCount, forKey: Keys.openAppCount)
//    }
//}


import Foundation
import Combine
import AdMobManager

class Global {
    static let shared = Global()
    
    private var subscriptions = [AnyCancellable]()
    private(set) var allowShowAppOpen = false
}

extension Global {
    func fetch() {
        if !UserDefaults.standard.bool(forKey: "isShowCMP") {
            showCMP()
        }
        if let url = Bundle.main.url(forResource: "AdMobDefaultValue", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            AdMobManager.shared.register(defaultData: data)
        }
    }
    
    func setShowAppOpen(allow: Bool) {
        self.allowShowAppOpen = allow
    }
    
    func showCMP() {
        AdMobManager.shared.activeDebug(testDeviceIdentifiers: ["0A982B71-32E8-42D0-9580-5737A2C3FAEA"],
                                        reset: false)
        UserDefaults.standard.set(true, forKey: "isShowCMP")
    }
}
