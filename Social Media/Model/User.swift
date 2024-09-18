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
    public var likes: [String]
    public var images: [String]
    
    public init(email: String, name: String = "Unknown", image: String = "default", status: String = "", likes: [String] = [], images: [String] = []) {
        self.email = email
        self.name = name
        self.image = image
        self.status = status
        self.likes = likes
        self.images = images
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "image": image,
            "status": status,
            "likes": likes,
            "images": images
        ]
    }
}
