//
//  MainCoordinator.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2024.
//

import UIKit

class MainCoordinator: Coordinator {

    var navigationController: UINavigationController
        
    var controllers = [UIViewController]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func addFeedViewController() {
        let feedService = FeedService()
        let feedViewModel = FeedVMOutput(service: feedService)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.title = "Feed"
        let feedImage = UIImage(systemName: "house.circle")
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: feedImage, tag: 0)
        controllers.append(feedViewController)
    }
    
    func addLogInViewController() {
        let logInViewController = LogInViewController()
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector(viewController: logInViewController)
        logInViewController.loginDelegate = loginInspector
        logInViewController.title = "Log In"
        let logInImage = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        logInViewController.tabBarItem = UITabBarItem(title: nil, image: logInImage, tag: 1)
        controllers.append(logInViewController)
    }
    
    func addSecretWordViewController() {
        let secretWordViewController = SecretWordViewController(secretWord: "secret")
        let secretWordImage = UIImage(systemName: "dice.fill")
        secretWordViewController.tabBarItem = UITabBarItem(title: nil, image: secretWordImage, tag: 2)
        controllers.append(secretWordViewController)
    }
    
    func start() {
        addFeedViewController()
        addLogInViewController()
        addSecretWordViewController()
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        tabBarController.selectedIndex = 0
        
        navigationController.pushViewController(tabBarController, animated: false)

    }
}
