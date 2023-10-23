//
//  LoginViewControllerDelegate.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}

// Через структуру сделать не получается :(
class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.check(login: login, password: password)
    }
}
