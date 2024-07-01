//
//  Checker.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

// LEGACY CODE
// SUBJECT TO REMOVE
import Foundation

class Checker {
    private static var passwords: Dictionary = [
        "default":"AAA",
        "strawberry_moose":"1234",
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
                    return user
                }
            }
            
            throw AppError.passwordIncorrect
            
        case .failure(let error):
            throw error
        }
    }
    
    static func getPassword(login: String) throws -> String? {
        
        let result = try getUser(login: login)
        
        switch result {
        case .success(let user):
            for (key, value) in passwords {
                if (key == user.login) {
                    return value
                }
            }
        case .failure(let error):
            throw error
        }
        
        return nil
    }
}

