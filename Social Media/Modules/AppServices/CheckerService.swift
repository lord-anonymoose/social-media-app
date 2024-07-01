//
//  CheckerService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 01.07.2024.
//

import Foundation
import Firebase
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, CheckerError>) -> Void)
    func singUp(email: String, password: String)
    func getUser(email: String) -> User
}

final class CheckerService: CheckerServiceProtocol {
    func singUp(email: String, password: String) {
        print("")
    }
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, CheckerError>) -> Void) {
        if !email.contains("@media.com") {
            completion(.failure(CheckerError.invalidEmail))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if email == "" {
                completion(.failure(CheckerError.emptyLogin))
                return
            }
            
            if password == "" {
                completion(.failure(CheckerError.emptyPassword))
                return
            }
            
            if error != nil {
                completion(.failure(CheckerError.wrongCredentials))
                return
            } else {
                let login = email.replacingOccurrences(of: "@media.com", with: "")
                var user: User? = nil
                for usr in users {
                    if usr.login == login {
                        user = usr
                    }
                }
                if let result = user {
                    print(result)
                    completion(.success(result))
                    return
                } else {
                    completion(.failure(CheckerError.userNotExist))
                    return
                }
            }
        }
    }
    
    func singUp() {
        print("")
    }
    
    func getUser(email: String) -> User {
        
        print("")
        return User(login: "", name: "")
    }
    
    
}
