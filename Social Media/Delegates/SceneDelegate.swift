//
//  SceneDelegate.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit
import FirebaseAuth
import LocalAuthentication
import UserNotifications
import FirebaseDatabase


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
                               
        let window = UIWindow(windowScene: scene)
                
        let loadingViewController = LoadingViewController()
        let navigationController = UINavigationController(rootViewController: loadingViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Added
        let preferredTheme = UserDefaults.standard.integer(forKey: "preferredTheme")
        applyTheme(preferredTheme)
        
        self.window = window
        
        let loginViewController = LogInViewController()
        let newNavigationController = UINavigationController(rootViewController: loginViewController)
                
        do {
            guard let id = try FirebaseService.shared.currentUserID() else {
                window.rootViewController = newNavigationController
                return
            }
            FirebaseService.shared.fetchUser(by: id) { user in
                if let user {
                    let secondaryLoginViewController = SecondaryLoginViewController(user: user)
                    let newNavigationController = UINavigationController(rootViewController: secondaryLoginViewController)
                    window.rootViewController = newNavigationController
                } else {
                    window.rootViewController = newNavigationController
                }
            }
        } catch {
            let loginViewController = LogInViewController()
            let newNavigationController = UINavigationController(rootViewController: loginViewController)
            window.rootViewController = newNavigationController
            return
        }
    }
    
    func applyTheme(_ theme: Int) {
        switch theme {
        case 1:
            window?.overrideUserInterfaceStyle = .light
        case 2:
            window?.overrideUserInterfaceStyle = .dark
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

        //let authType = LocalAuthorizationService.biometricType()
        /*
        if authType == .none {
            do {
                try Auth.auth().signOut()
                print("Signed out!")
            } catch {}
        }
        */
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
    }


}
