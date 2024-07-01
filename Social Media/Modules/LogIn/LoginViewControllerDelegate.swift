//
//  LoginViewControllerDelegate.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

import UIKit

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> StorageService.User?
}

struct LoginInspector: LoginViewControllerDelegate {

    var viewController: UIViewController
    
    func check(login: String, password: String) -> StorageService.User? {
        do {
            return try Checker.check(login: login, password: password)
        }
        catch AppError.userNotExist {
            print("User does not exist")
            showAlert(error: .userNotExist)
        }
        catch AppError.passwordIncorrect {
            print("Password is incorrect")
            showAlert(error: .passwordIncorrect)
        }
        catch {
            print("Unknown error")
        }
        return nil
    }
    
    func showAlert(error: AppError) {
        let title = "Error!"
        let message = error.description
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

protocol LoginFactory {
    func makeLoginInspector(viewController: UIViewController) -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector(viewController: UIViewController) -> LoginInspector {
        let inspector = LoginInspector(viewController: viewController)
        return inspector
    }
}

