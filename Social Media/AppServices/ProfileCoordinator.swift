//
//  ProfileCoordinator.swift
//  Social Media
//
//  Created by Philipp Lazarev on 11.06.2024.
//

import UIKit
import FirebaseAuth



protocol Coordinator {
    func start()
}


class ProfileCoordinator: Coordinator {
    
    var user = StorageService.User(login: "default", name: "default")
    var navigationController: UINavigationController
    var controllers = [UIViewController]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func authenticate(user: StorageService.User) {
        self.user = user
    }
    
    func start() {
        addFeedViewController()
        addProfileviewController()
        addLikesViewController()
        
        let tabBarViewController = UITabBarController()
        
        tabBarViewController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        tabBarViewController.selectedIndex = 0
        navigationController.pushViewController(tabBarViewController, animated: false)
        self.navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Signed out!")
        } catch {
            print("Couldn't logout")
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let loginViewController = LogInViewController() // Replace with your view controller initialization
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    // Feed
    func addFeedViewController() {
        let feedService = FeedService()
        let feedViewModel = FeedVMOutput(service: feedService)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        let feedImage = UIImage(systemName: "house.circle")
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: feedImage, tag: 0)
        controllers.append(feedViewController)
    }
    
    // Profile
    func addProfileviewController() {
        let profileViewController = ProfileViewController(user: user)
        let profileViewImage = UIImage(systemName: "person.fill")
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: profileViewImage, tag: 1)
        controllers.append(profileViewController)
    }
    
    // Secret Word
    func addSecretWordViewController() {
        let secretWordViewController = SecretWordViewController(secretWord: "secret")
        let secretWordImage = UIImage(systemName: "dice.fill")
        secretWordViewController.tabBarItem = UITabBarItem(title: nil, image: secretWordImage, tag: 2)
        controllers.append(secretWordViewController)
    }
    
    // Planet
    func addPlanetViewController() {
        let planetViewController = PlanetViewController()
        let planetImage = UIImage(systemName: "globe.americas.fill")
        planetViewController.tabBarItem = UITabBarItem(title: nil, image: planetImage, tag: 2)
        controllers.append(planetViewController)
    }
    
    func addLikesViewController() {
        let likesViewController = LikesViewController()
        let likesImage = UIImage(systemName: "heart.fill")
        likesViewController.tabBarItem = UITabBarItem(title: nil, image: likesImage, tag: 2)
        controllers.append(likesViewController)
    }
}
