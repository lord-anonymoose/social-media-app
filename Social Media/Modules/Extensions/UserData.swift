//
//  UserData.swift
//  Social Media
//
//  Created by Philipp Lazarev on 04.07.2023.
//

import StorageService
import UserService


func getUser(login: String) -> StorageService.User {
    for user in UserService.users {
        if user.login == login {
            return user
        }
    }
    return UserService.users[0] // default user
}

public var strawberry_moose = StorageService.User(login: "strawberry_moose", name: "Philipp Lazarev")
public var katyperry = StorageService.User(login: "katyperry", name: "Katy Perry")
public var teddyphotos = StorageService.User(login: "teddyphotos", name: "Ed Sheeran")
public var joebiden = StorageService.User(login: "joebiden", name: "Joe Biden")
public var timcook = StorageService.User(login: "tim_cook", name: "Tim Cook")
public var ryantedder = StorageService.User(login: "ryantedder", name: "Ryan Tedder")
public var billieeilish = StorageService.User(login: "billieeilish", name: "Billie Eilish")
public var ijustine = StorageService.User(login: "ijustine", name: "iJustine")
public var mkbhd = StorageService.User(login: "mkbhd", name: "Marques Brownlee")
public var defaultUser = StorageService.User(login: "default", name: "default")

