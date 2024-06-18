//
//  ProfileCoordinator.swift
//  Social Media
//
//  Created by Philipp Lazarev on 11.06.2024.
//

import UIKit

class ProfileCoordinator: Coordinator {
    
    var user = StorageService.User(login: "default", name: "default")
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func authenticate(user: StorageService.User) {
        self.user = user
    }
    
    func updateTabBar(tabBarController: UITabBarController) {
        tabBarController.tabBar.items?[1].image = UIImage(systemName: "person.crop.circle")
        tabBarController.tabBar.items?[1].title = nil
    }
    
    func start() {
        let profileViewController = ProfileViewController(user: user)
        navigationController.pushViewController(profileViewController, animated: true)
    }
}
