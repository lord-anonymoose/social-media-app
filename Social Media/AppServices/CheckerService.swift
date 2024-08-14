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
import Network


protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func singUp(email: String, password: String)
}

final class CheckerService: CheckerServiceProtocol {
    
    func singUp(email: String, password: String) {
        print("")
    }
    
    /*
    private func checkNetworkAvailability(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkCheck")

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            } else {
                completion(false)
            }
            monitor.cancel() // Stop monitoring after the first check
        }

        monitor.start(queue: queue)
    }
     */
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if email.isEmpty {
            completion(.failure(CheckerError.emptyLogin))
            return
        }
        
        if password.isEmpty {
            completion(.failure(CheckerError.emptyPassword))
            return
        }
        
        if !email.contains("@media.com") {
            completion(.failure(CheckerError.invalidEmail))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
                
            let login = email.replacingOccurrences(of: "@media.com", with: "")
            self.getUser(username: login) { user in
                if let user = user {
                    completion(.success(user))
                } else {
                    completion(.failure(CheckerError.userNotExist))
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
                }
            }
            
            completion(users)
        }) { error in
            print("Error fetching usernames: \(error.localizedDescription)")
            completion([])
        }
    }
    
    func getUser(username: String, completion: @escaping (User?) -> Void) {
        self.fetchUsernames { users in
            for user in users {
                if user.login == username {
                    completion(user)
                    return
                }
            }
            completion(nil)
        }
    }
    
    func addUserToDatabase(login: String, name: String) {
        let ref = Database.database().reference().child("users")
        ref.child(login).setValue(name) { error, _ in
            if error != nil {
                //let message = String(localized: "Could not add user to database!", comment: "Error message")
                print("Could not add user to database!")
            } else {
                print("User \(name) added to database!")
            }
        }
    }
}
