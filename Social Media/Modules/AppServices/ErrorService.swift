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
            return "Failed working with datatype"
        case .userNotExist:
            return "Such user does not exist!"
        case .passwordIncorrect:
            return "Password is incorrect!"
        case .networkError:
            return "Your connection is lost!"
        case .noImages:
            return "No images to present!"
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
            return "The URL is not valid!"
        case .jsonError:
            return "Couldn't parse JSON data!"
        case .networkError:
            return "Your connection is lost!"
        case .httpResponseError:
            return "HTTP Response Error!"
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
}

extension CheckerError {
    public var description: String {
        switch self {
        case .invalidEmail:
            return "An email is invalid!"
        case .emptyLogin:
            return "A login field can not be empty!"
        case .emptyPassword:
            return "A password field can not be empty!"
        case .wrongCredentials:
            return "Wrong credentials!"
        case .passwordsNotMatching:
            return "Passwords do not match!"
        case .userNotExist:
            return "User doesn't exist!"
        }
    }
}
