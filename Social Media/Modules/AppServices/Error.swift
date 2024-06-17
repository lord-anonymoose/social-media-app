//
//  Error.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.06.2024.
//

import Foundation

enum AppError: Error {
    case datatypeError
    case userNotExist
    case passwordIncorrect
    case networkError
}

extension AppError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .datatypeError:
            return "..."
        case .userNotExist:
            return "Such user does not exist!"
        case .passwordIncorrect:
            return "Password is incorrect!"
        case .networkError:
            return "Your connection is lost!"
        }
    }
}
