//
//  ProfileCoordinator.swift
//  Social Media
//
//  Created by Philipp Lazarev on 11.06.2024.
//

import UIKit
import FirebaseAuth


protocol Coordinator {
    func login()
    func logout()
}


class MainCoordinator: Coordinator, ObservableObject {
    
    var navigationController: UINavigationController
    var controllers = [UIViewController]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func login() {
        addFeedViewController()
        addProfileViewController { [weak self] in
            guard let self = self else { return }

            let tabBarViewController = UITabBarController()
            tabBarViewController.viewControllers = self.controllers.map {
                UINavigationController(rootViewController: $0)
            }
            tabBarViewController.selectedIndex = 0
            self.navigationController.pushViewController(tabBarViewController, animated: false)
            self.navigationController.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let loginViewController = LogInViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        window.rootViewController = navigationController
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func showSignUpViewController() {
        let signUpViewController = SignUpViewController()
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func popToPreviousViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }

    func showResetPasswordViewController() {
        let resetPasswordViewController = ResetPasswordViewController()
        navigationController.pushViewController(resetPasswordViewController, animated: true)
    }
    
    func showLogInViewController() {
        let loginViewController = LogInViewController()
        navigationController.viewControllers = [loginViewController]
        navigationController.popToRootViewController(animated: true)
    }
    
    func showOtherProfileViewControll(user: User, userID: String) {
        let otherProfileViewController = ProfileViewController(user: user, isMyUser: false, userID: userID)
        navigationController.pushViewController(otherProfileViewController, animated: true)
    }
    
    func showProfilePicViewController(image: UIImage) {
        let picturePickerViewController = PicturePickerViewController(image: image)
        navigationController.pushViewController(picturePickerViewController, animated: true)
    }
    
    func showSettingsViewController(image: UIImage) {
        if let id = Auth.auth().currentUser?.uid {
            FirebaseService.shared.fetchUser(by: id) { user in
                if let user = user {
                    let settingsViewController = SettingsViewController(name: user.name, status: user.status)
                    self.navigationController.pushViewController(settingsViewController, animated: true)
                    
                } else {
                    print("User not found")
                }
            }
        } else {
            print("Not logged in")
        }
    }
    
    // Profile
    func addProfileViewController(completion: @escaping () -> Void) {
        let id = Auth.auth().currentUser?.uid
        print(id ?? "Not found")
        
        FirebaseService.shared.fetchUser(by: id ?? "0") { user in
            if let user = user {
                print("My user is: \(user.name)")
                let profileViewController = ProfileViewController(user: user, isMyUser: true, userID: id ?? "Unknown")
                let profileViewImage = UIImage(systemName: "person.fill")
                profileViewController.tabBarItem = UITabBarItem(title: nil, image: profileViewImage, tag: 1)
                self.controllers.append(profileViewController)
            } else {
                print("User not found")
            }
            completion() // Call the completion handler after fetching the user
        }
    }
    
    func addFeedViewController() {
        let feedViewController = FeedViewController()
        let feedViewImage = UIImage(systemName: "house.circle")
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: feedViewImage, tag: 2)
        controllers.append(feedViewController)
    }
}
