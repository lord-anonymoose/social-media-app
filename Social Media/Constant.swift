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

var billGates = User(login: "BillGates", name: "Bill Gates")
var joeBiden = User(login: "JoeBiden", name: "Joe Biden")
var katyPerry = User(login: "katyperry", name: "Katy Perry")
var timCook = User(login: "tim_cook", name: "Tim Cook")
var mkbhd = User(login: "MKBHD", name: "Marques Brownlee")
var lisaJackson = User(login: "lisapjackson", name: "Lisa P. Jackson")
var defaultUser = User(login: "default", name: "default")

public var me = User(login: "strawberry_moose", name: "Philipp Lazarev")

public var users = [billGates, joeBiden, katyPerry, timCook, mkbhd, lisaJackson, me]
//public var users = [User]()

public struct oldPost {
    let id = UUID()
    var user: User
    var text: String
    
    init(user: User, text: String) {
        self.user = user
        self.text = text
    }
}



// Following posts are totally imaginary and do not represent any thoughts or quotes from mentioned users
public var posts = [
    oldPost(user: timCook, text: "Can't wait for some BIG announcements on WWDC 2023! See you June 5th!"),
    oldPost(user: katyPerry, text: "Got sum new music for y'all 👀"),
    oldPost(user: billGates, text: "Let's work together to make the world a better place."),
    oldPost(user: mkbhd, text: "The Google Pixel 7a is looking like a solid mid-range option for those who want a great camera and pure Android experience."),
    oldPost(user: joeBiden, text: "Addressing inflation is a top priority for my administration to ensure that hardworking Americans can afford the essentials they need to thrive."),
    oldPost(user: katyPerry, text: "Congratulations @edsheeran on your new album release, can't wait to listen to all the amazing songs!"),
]

let accentColor = UIColor(hex: "#4885CC")

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

public var myPosts = [
    Post(author: me.login, description: "Breathtaking Dublin ☘️🇮🇪", image: "post1", likes: 96, views: 100),
    Post(author: me.login, description: "Wonderful Madrid 🐻🇪🇸", image: "post2", likes: 90, views: 99),
    Post(author: me.login, description: "Warm Tbilisi ☀️🇬🇪", image: "post3", likes: 89, views: 96 ),
    Post(author: me.login, description: "Calm Paderborn 🏰🇩🇪", image: "post4", likes: 88, views: 95)
]
