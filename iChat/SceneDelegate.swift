//
//  SceneDelegate.swift
//  iChat
//
//  Created by Илья Синицын on 04.07.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    
        if let user = Auth.auth().currentUser {
            FirestoreServiceManager.shared.getUserData(user: user) { (reault) in
                switch reault {
                case .success(let muser):
                    let mainTabBar = MainTabBarController(currentUser: muser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = mainTabBar
                case .failure(_):
                    self.window?.rootViewController = AuthViewController()
                }
            }
        } else {
            window?.rootViewController = AuthViewController()
        }
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
