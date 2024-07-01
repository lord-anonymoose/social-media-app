//
//  CheckerService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 01.07.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, CheckerError>) -> Void)
    func singUp(email: String, password: String)
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
                print("Current login: \(login)")
                var user: User? = nil
                
                var fetchedUsers = [User]()
                
                self.fetchUsernames { users in
                    fetchedUsers = users
                    
                    for usr in fetchedUsers {
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
    }
}

extension CheckerService {
    private func fetchUsernames(completion: @escaping ([User]) -> Void) {
        let ref = Database.database().reference().child("users")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            var users = [User]()
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let name = child.value as? String {
                    users.append(User(login: child.key, name: name))
                    print(name)
                }
            }
            
            completion(users)
        }) { error in
            print("Error fetching usernames: \(error.localizedDescription)")
            completion([])
        }
    }
}
