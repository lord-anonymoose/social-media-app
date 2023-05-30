//
//  Constant.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import Foundation

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

public var users = [billGates, joeBiden, katyPerry, timCook, mkbhd, lisaJackson]
//public var users = [User]()

public struct Post {
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
    Post(user: timCook, text: "Can't wait for some BIG announcements on WWDC 2023! See you June 5th!"),
    Post(user: katyPerry, text: "Got sum new music for y'all 👀"),
    Post(user: billGates, text: "Let's work together to make the world a better place."),
    Post(user: mkbhd, text: "The Google Pixel 7a is looking like a solid mid-range option for those who want a great camera and pure Android experience."),
    Post(user: joeBiden, text: "Addressing inflation is a top priority for my administration to ensure that hardworking Americans can afford the essentials they need to thrive."),
    Post(user: katyPerry, text: "Congratulations @edsheeran on your new album release, can't wait to listen to all the amazing songs!"),
]
