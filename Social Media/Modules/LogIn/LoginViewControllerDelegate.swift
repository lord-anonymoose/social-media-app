//
//  LoginViewControllerDelegate.swift
//  Social Media
//
//  Created by Philipp Lazarev on 23.10.2023.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
