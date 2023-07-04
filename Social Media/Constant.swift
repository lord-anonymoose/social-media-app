//
//  Constant.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import Foundation
import UIKit

public struct User {
    let id = UUID()
    var login: String
    var name: String
    
    init(login: String, name: String) {
        self.login = login
        self.name = name
    }
}

let accentColor = UIColor(hex: "#01937C")
let secondaryColor = UIColor(hex: "#FFC074")

public struct Post {
    let id = UUID()
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
    
    init(author: String, description: String, image: String, likes: Int, views: Int) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}
