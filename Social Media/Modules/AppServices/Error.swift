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
        }
    }
}
