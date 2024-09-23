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
    case noImageToUpload
    
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
        case .noImageToUpload:
            return "No image found for upload".localized
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
        }
        return id
    }
    
    private func checkIfEmailIsVerified() async -> Bool {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return false
        }
        
        do {
            try await user.reload()
            return user.isEmailVerified
        } catch {
            print("Failed to reload user: \(error.localizedDescription)")
            return false
        }
    }
    
    func signIn(email: String, password: String) async throws {
        guard email.isValidEmail() else {
            throw FirebaseServiceError.invalidEmail
        }
        
        guard !password.isEmpty else {
            throw FirebaseServiceError.emptyPassword
        }
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = authResult.user.uid
            
            let isVerified = await checkIfEmailIsVerified()
            
            if isVerified {
                print("Email is verified")
                let userExists = try await checkIfUserExistsInDatabase(uid: uid)
                
                if !userExists {
                    let newUser = User(email: email)
                    try await addCurrentUserToDatabase(user: newUser)
                    print("New user added to database.")
                } else {
                    print("User already exists in the database.")
                }
            } else {
                print("User is not verified")
                try await authResult.user.sendEmailVerification()
                try signOut()
            }
        } catch {
            if error.localizedDescription.contains("The supplied auth credential is malformed or has expired.") {
                throw FirebaseServiceError.wrongPassword
            } else {
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
            try await self.deleteCurrentUserFromDatabase()
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
    
    private func checkIfUserExistsInDatabase(uid: String) async throws -> Bool {
        let databaseRef = Database.database().reference()
        let snapshot = try await databaseRef.child("users").child(uid).getData()
        
        return snapshot.exists()
    }

    private func addCurrentUserToDatabase(user: User) async throws {
        guard let uid = try self.currentUserID() else {
            throw FirebaseServiceError.userNotExist
        }
        let databaseRef = Database.database().reference()
        try await databaseRef.child("users").child(uid).setValue(user.toDictionary())
    }
    
    private func deleteCurrentUserFromDatabase() async throws {
        guard let uid = try self.currentUserID() else {
            throw FirebaseServiceError.userNotExist
        }
        let databaseRef = Database.database().reference()
        try await databaseRef.child("users").child(uid).removeValue()
    }
    
    
    func updateUserImage(newImage: UIImage?, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let image = newImage else {
            completion(.failure(FirebaseServiceError.noImageToUpload))
            return
        }
        
        // 2. Convert the image to JPEG data with a compression quality (adjust quality as needed)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Could not convert image to data")
            return
        }
        
        // 3. Create a unique filename for the image (for example, using a timestamp)
        guard let id = Auth.auth().currentUser?.uid else {
            completion(.failure(FirebaseServiceError.userNotExist))
            return
        }
        
        let filename = "ProfilePictures/\(id).jpg"
        
        // 4. Create a reference to Firebase Storage
        let storageRef = Storage.storage().reference().child(filename)
        
        // 5. Upload the image data to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 6. Optionally, get the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let downloadURL = url {
                    print("Image uploaded successfully, download URL: \(downloadURL)")
                    completion(.success(downloadURL))
                }
            }
        }
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

    func updateUserInformation(newName: String, newStatus: String) async throws {
        if let id = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference()
            do {
                try await databaseRef.child("users").child(id).child("name").setValue(newName)
                try await databaseRef.child("users").child(id).child("status").setValue(newStatus)
            } catch {
                throw FirebaseServiceError.firebaseError(error.localizedDescription)
            }
        }
    }
}
