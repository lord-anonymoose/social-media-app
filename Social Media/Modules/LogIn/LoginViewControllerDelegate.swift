//
//  LoginViewControllerDelegate.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.check(login: login, password: password)
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        let inspector = LoginInspector()
        return inspector
    }
}
