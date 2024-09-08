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


enum FirebaseServiceError: Error, LocalizedError {
    case invalidEmail
    case emptyPassword
    case passwordsNotMatch
    case firebaseError(String)
    case wrongPassword
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "The email address is not valid."
        case .emptyPassword:
            return "The password field cannot be empty."
        case .passwordsNotMatch:
            return "Passwords do not match."
        case .firebaseError(let message):
            return message
        case .wrongPassword:
            return "Wrong credentials!"
        }
    }
}

final class FirebaseService {
    
    private let logger = Logger()
    
    static func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    // Registering a new user
    static func signUp(email: String, password1: String, password2: String) async throws {
        
        // Email check
        guard email.isValidEmail() else {
            throw FirebaseServiceError.invalidEmail
        }
        
        // Password check
        guard !password1.isEmpty && !password2.isEmpty else {
            throw FirebaseServiceError.emptyPassword
        }
        
        // Passwords match check
        guard password1 == password2 else {
            throw FirebaseServiceError.passwordsNotMatch
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password1)
            print(Auth.auth().currentUser ?? "Not logged in")
            try await authResult.user.sendEmailVerification()
            print("User created and verification email sent")
            do {
                try self.signOut()
            } catch {
                throw FirebaseServiceError.firebaseError(error.localizedDescription)
            }
        } catch {
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
    
    // Logging in with existing user
    static func login(email: String, password: String) async throws {
        
        // Email check
        guard email.isValidEmail() else {
            print(FirebaseServiceError.invalidEmail.localizedDescription)
            throw FirebaseServiceError.invalidEmail
        }
        
        // Password check
        guard !password.isEmpty else {
            print(FirebaseServiceError.emptyPassword.localizedDescription)
            throw FirebaseServiceError.emptyPassword
        }
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            let user = authResult.user
            print("User \(user.email ?? "") successfully logged in.")
            
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
    
    static func resetPassword(email: String) async throws {
        guard email.isValidEmail() else {
            print(FirebaseServiceError.invalidEmail.localizedDescription)
            throw FirebaseServiceError.invalidEmail
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Email sent")
        } catch {
            print(error.localizedDescription)
            throw FirebaseServiceError.firebaseError(error.localizedDescription)
        }
    }
}
