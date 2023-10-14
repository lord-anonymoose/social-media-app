//
//  UserService.swift
//  UserService
//
//  Created by Philipp Lazarev on 13.10.2023.
//

import Foundation
import StorageService

protocol UserService {
    func checkUser(login: String) -> StorageService.User?
}

public class CurrentUserService {
    public init() {}
    
    public func checkUser(login: String?) -> StorageService.User? {
        for user in users {
            if user.login == login {
                return user
            }
        }
        return nil
    }
}

public class TestUserService {
    public init() {}
    
    public func checkUser(login: String?) -> StorageService.User? {
        return users[0]
    }
}

public var users = [
    StorageService.User(login: "default", name: "default"),
    StorageService.User(login: "strawberry_moose", name: "Philipp Lazarev"),
    StorageService.User(login: "katyperry", name: "Katy Perry"),
    StorageService.User(login: "teddyphotos", name: "Ed Sheeran"),
    StorageService.User(login: "joebiden", name: "Joe Biden"),
    StorageService.User(login: "tim_cook", name: "Tim Cook"),
    StorageService.User(login: "ryantedder", name: "Ryan Tedder"),
    StorageService.User(login: "billieeilish", name: "Billie Eilish"),
    StorageService.User(login: "ijustine", name: "iJustine"),
    StorageService.User(login: "mkbhd", name: "Marques Brownlee")
]
