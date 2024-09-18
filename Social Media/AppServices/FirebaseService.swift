//
//  UserService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 04.09.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Network
import os
import FirebaseStorage



enum FirebaseServiceError: Error, LocalizedError {
    case invalidEmail
    case emptyPassword
    case passwordsNotMatch
    case firebaseError(String)
    case wrongPassword
    case userNotExist
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "The email address is not valid.".localized
        case .emptyPassword:
            return "The password field cannot be empty.".localized
        case .passwordsNotMatch:
            return "Passwords do not match.".localized
        case .firebaseError(let message):
            return message
        case .wrongPassword:
            return "Wrong credentials!".localized
        case .userNotExist:
            return "User doesn't exist!".localized
        }
    }
}

final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private init() {
        
    }
    
    func currentUserID() throws -> String? {
        guard let id = Auth.auth().currentUser?.uid else {
            throw FirebaseServiceError.userNotExist
            //print("User not found")
        }
        return id
    }
    
    func signIn(email: String, password: String) async throws {
        
        guard email.isValidEmail() else {
            print(FirebaseServiceError.invalidEmail.localizedDescription)
            throw FirebaseServiceError.invalidEmail
        }
        
        guard !password.isEmpty else {
            print(FirebaseServiceError.emptyPassword.localizedDescription)
            throw FirebaseServiceError.emptyPassword
        }
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = authResult.user.uid

            // Check if user exists in Realtime Database
            let userExists = try await checkIfUserExistsInDatabase(uid: uid)

            if !userExists {
                let newUser = User(email: email)
                try await addUserToDatabase(uid: uid, user: newUser)
                print("New user added to database.")
            } else {
                print("User already exists in the database.")
            }
            
        } catch {
            if error.localizedDescription.contains("The supplied auth credential is malformed or has expired.") {
                print(FirebaseServiceError.wrongPassword.localizedDescription)
                throw FirebaseServiceError.wrongPassword
            } else {
                print(error.localizedDescription)
                throw FirebaseServiceError.firebaseError(error.localizedDescription)
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    func signUp(email: String, password1: String, password2: String) async throws {
        
        guard email.isValidEmail() else {
            throw FirebaseServiceError.invalidEmail
        }
        
        guard !password1.isEmpty && !password2.isEmpty else {
            throw FirebaseServiceError.emptyPassword
        }
        
        guard password1 == password2 else {
            throw FirebaseServiceError.passwordsNotMatch
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password1)
            try await authResult.user.sendEmailVerification()
            do {
                try signOut()
            } catch {
                throw FirebaseServiceError.firebaseError(error.localizedDescription)
            }
            
        } catch {
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    func deleteCurrentUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseServiceError.userNotExist
        }
        
        do {
            try await self.deleteUserFromDatabase(uid: user.uid)
        } catch {
            print("Couldn't delete folder from database: \(error.localizedDescription)")
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
        
        do {
            try await user.delete()
            print("User successfully deleted from Firebase Authentication.")
        } catch {
            print("Error deleting user: \(error.localizedDescription)")
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    func checkIfEmailIsRegistered(email: String, completion: @escaping (Bool) -> Void) {
        let fakePassword = "SomeRandomPassword123!"

        Auth.auth().createUser(withEmail: email, password: fakePassword) { (authResult, error) in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                authResult?.user.delete(completion: { error in
                    if let error = error {
                        print("Ошибка при удалении пользователя: \(error.localizedDescription)")
                    }
                    completion(false)
                })
            }
        }
    }
    
    func checkIfUserExistsInDatabase(uid: String) async throws -> Bool {
        let databaseRef = Database.database().reference()
        let snapshot = try await databaseRef.child("users").child(uid).getData()
        
        return snapshot.exists()
    }

    func addUserToDatabase(uid: String, user: User) async throws {
        let databaseRef = Database.database().reference()
        try await databaseRef.child("users").child(uid).setValue(user.toDictionary())
    }
    
    func deleteUserFromDatabase(uid: String) async throws {
        let databaseRef = Database.database().reference()
        try await databaseRef.child("users").child(uid).removeValue()
    }
    
    func resetPassword(email: String) async throws {
        guard email.isValidEmail() else {
            print(FirebaseServiceError.invalidEmail.localizedDescription)
            throw FirebaseServiceError.invalidEmail
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print(error.localizedDescription)
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    func fetchUser(by uid: String, completion: @escaping (User?) -> Void) {
        let databaseRef = Database.database().reference()
        
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("User with UID \(uid) not found")
                Task {
                    do {
                        try FirebaseService.shared.signOut()
                    }
                }
                completion(nil)
                return
            }
            
            let email = value["email"] as? String ?? ""
            let name = value["name"] as? String ?? "Unknown"
            let image = value["image"] as? String ?? "default"
            let status = value["status"] as? String ?? ""
            let likes = value["likes"] as? [String] ?? []
            let images = value["images"] as? [String] ?? []
            
            let user = User(email: email, name: name, image: image, status: status, likes: likes, images: images)
            
            completion(user)
        }) { error in
            print("Error fetching user: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func setUserStatus(newStatus: String, for userID: String) async throws {
        let databaseRef = Database.database().reference()

        do {
            try await databaseRef.child("users").child(userID).child("status").setValue(newStatus)
        } catch {
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
}
