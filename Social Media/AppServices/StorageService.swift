//
//  StorageService.swift
//  StorageService
//
//  Created by Philipp Lazarev on 08.09.2023.
//

import Foundation
import UIKit

public class StorageService {
    
    public struct User {
        let id = UUID()
        public var login: String
        public var name: String
        public var image: UIImage
        public var status: String?
        
        public init(login: String, name: String) {
            self.login = login
            self.name = name
            self.image = UIImage(named: login) ?? UIImage(named: "default")!
        }
    }
    
    public struct Post {
        let id = UUID()
        public let author: String
        public let description: String
        public let image: String
        public let likes: Int
        public let views: Int
        
        public init(author: String, description: String, image: String, likes: Int, views: Int) {
            self.author = author
            self.description = description
            self.image = image
            self.likes = likes
            self.views = views
        }
    }
}

typealias User = StorageService.User
typealias Post = StorageService.Post
