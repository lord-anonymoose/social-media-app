//
//  Checker.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

import Foundation

class Checker {
    private static var passwords: Dictionary = [
        "default":"default",
        "strawberry_moose":"3sfQasf23d_&3",
        "katyperry":"uU3d^csaaqw",
        "teddyphotos":"%Edc_Swdcd21",
        "joebiden":"s2esdSQd22&$",
        "tim_cook":"WDjdd_23ds2",
        "ryantedder":"dd&ghrjkx_dwas",
        "billieeilish":"83a1_93JFfdaz",
        "ijustine":"!ddffgccd_*753s",
        "mkbhd":"$ffdQ-ffcx87$",
    ]
    
    private init() {}

    static func check(login: String, password: String) throws -> StorageService.User? {
        
        let result = try getUser(login: login)
        
        switch result {
        case .success(let user):
            for (key, value) in passwords {
                if (key == login) && (value == password) {
                    let userService = CurrentUserService()
                    return user
                }
            }
            
            throw appError.passwordIncorrect
            
        case .failure(let error):
            throw error
        }
    }
}

