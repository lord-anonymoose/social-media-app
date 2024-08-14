//
//  Error.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.06.2024.
//

import Foundation

// Basic App Functionality Errors
enum AppError: Error {
    case datatypeError
    case userNotExist
    case passwordIncorrect
    case networkError
    case noImages
}

extension AppError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .datatypeError:
            return String(localized: "Failed working with datatype", comment: "Error message")
        case .userNotExist:
            return String(localized: "Such user does not exist!", comment: "Error message")
        case .passwordIncorrect:
            return String(localized: "Password is incorrect!", comment: "Error message")
        case .networkError:
            return String(localized: "Your connection is lost!", comment: "Error message")
        case .noImages:
            return String(localized: "No images to present!", comment: "Error message")
        }
        
    }
}


// Network Functionality Errors
enum NetworkError: Error {
    case urlError
    case jsonError
    case networkError
    case httpResponseError
}

extension NetworkError {
    public var description: String {
        switch self {
        case .urlError:
            return String(localized: "The URL is not valid!", comment: "Error message")
        case .jsonError:
            return String(localized: "Couldn't parse JSON data!", comment: "Error message")
        case .networkError:
            return String(localized: "Your connection is lost!", comment: "Error message")
        case .httpResponseError:
            return String(localized: "HTTP Response Error!", comment: "Error message")
        }
    }
}

// Checking user functionality
enum CheckerError: Error {
    case invalidEmail
    case emptyLogin
    case emptyPassword
    case wrongCredentials
    case passwordsNotMatching
    case userNotExist
    case networkNotAvailable
}

extension CheckerError {
    public var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return String(localized: "An email is invalid!", comment: "Error message")
        case .emptyLogin:
            return String(localized: "A login field can not be empty!", comment: "Error message")
        case .emptyPassword:
            return String(localized: "A password field can not be empty!", comment: "Error message")
        case .wrongCredentials:
            return String(localized: "Wrong credentials!", comment: "Error message")
        case .passwordsNotMatching:
            return String(localized: "Passwords do not match!", comment: "Error message")
        case .userNotExist:
            return String(localized: "User doesn't exist!", comment: "Error message")
        case .networkNotAvailable:
            return String(localized: "Network is not available!", comment: "Error message")
        }
    }
}
