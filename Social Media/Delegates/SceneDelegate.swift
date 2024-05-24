//
//  SceneDelegate.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

// Working on Task 7
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
                               
        let window = UIWindow(windowScene: scene)
        let tabBarController = UITabBarController()
        
        // Feed Tab
        let feedService = FeedService()
        let feedViewModel = FeedVMOutput(service: feedService)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.title = "Feed"
        let feedImage = UIImage(systemName: "house.circle")
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: feedImage, tag: 0)
        
        // Log In Tab
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()
        let logInViewController = LogInViewController()
        logInViewController.loginDelegate = loginInspector
        logInViewController.title = "Log In"
        let logInImage = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        logInViewController.tabBarItem = UITabBarItem(title: nil, image: logInImage, tag: 1)

        // Secret Word Game Tab (Task 6)
        let secretWordViewController = SecretWordViewController(secretWord: "secret")
        let secretWordImage = UIImage(systemName: "dice.fill")
        secretWordViewController.tabBarItem = UITabBarItem(title: nil, image: secretWordImage, tag: 2)
                         

        let controllers = [feedViewController, logInViewController, secretWordViewController]
        tabBarController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
         
        tabBarController.selectedIndex = 0
                        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
                 
        self.window = window
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
