//
//  SceneDelegate.swift
//  Moffy
//
//  Created by Trương Duy Tân on 30/01/2024.
//

import UIKit
import AdMobManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        CameraManager.shared.flashState = false
        CameraVC.isFlashOff.send(true)
        guard let topVC = UIApplication.topViewController() else {
          return
        }
        
        if AdMobManager.shared.state == .allow {
            AdMobManager.shared.show(type: .appOpen,
                                     name: "ID_Open_app",
                                     rootViewController: topVC,
                                     didFail: nil,
                                     didHide: nil)
        } 
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let windows = UIWindow(windowScene: windowScene)
        let navi = UINavigationController(rootViewController: SplashVC())
        navi.isNavigationBarHidden = true
        windows.rootViewController = navi
        self.window = windows
        windows.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
//        CameraManager.shared.didEnterBackground()
//        UIScreen.main.brightness = currentBrightness
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}
