//
//  SceneDelegate.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 1/10/2566 BE.
//

import UIKit
import FirebaseRemoteConfig
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        verifyVersion()
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
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

extension SceneDelegate {
    
//    func setupRemoteConfig(){
//        let remoteConfig = RemoteConfig.remoteConfig()
//
////        let defaults : [String : Any] = [
////            ForceUpdateChecker.IS_FORCE_UPDATE_REQUIRED : false,
////            ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION : "1.0.0(1)",
////            ForceUpdateChecker.FORCE_UPDATE_STORE_URL : "https://itunes.apple.com/br/app/myapp/id1291292682"
////        ]
//
//        let expirationDuration = 0
//
////        remoteConfig.setDefaults(defaults as? [String : NSObject])
//
//        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
//            if status == .success {
//                remoteConfig.activate()
//            } else {
//                print("Error: \(error?.localizedDescription ?? "No error available.")")
//            }
//        }
//    }

    func goToAppStore(action: UIAlertAction) {
        let appId = "1291292682"
        UIApplication.shared.openAppStore(for: appId)
    }

    func verifyVersion() {
//        setupRemoteConfig()

        if ForceUpdateChecker().check() == .shouldUpdate {
            let alert = UIAlertController(title: "New version avaiable",
                                          message: "There are new features avaiable, please update your app",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Update", style: .default, handler: goToAppStore)
            alert.addAction(action)
            window?.rootViewController?.present(alert, animated: true)
        }
    }
}
