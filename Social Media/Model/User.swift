//
//  User.swift
//  Social Media
//
//  Created by Philipp Lazarev on 12.09.2024.
//

import Foundation

struct User {
    var email: String
    var name: String
    var image: String
    var status: String
    var likes: [String]
    var images: [String]
    
    init(email: String, name: String = "Unknown", image: String = "default", status: String = "", likes: [String] = [], images: [String] = []) {
        self.email = email
        self.name = name
        self.image = image
        self.status = status
        self.likes = likes
        self.images = images
    }
    
    func toDictionary() -> [String: Any] {
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
