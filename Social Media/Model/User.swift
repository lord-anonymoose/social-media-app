//
//  User.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.09.2024.
//

import Foundation

public struct User {
    public var email: String
    public var name: String
    public var image: String
    public var status: String
    
    public init(email: String, name: String = "Unknown", image: String = "default", status: String = "") {
        self.email = email
        self.name = name
        self.image = image
        self.status = status
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "image": image,
            "status": status
        ]
    }
}
