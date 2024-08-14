//
//  UIViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    public func showErrorAlert(description: String) {
        let alert = UIAlertController(title: String(localized: "Error!"), message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "OK"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
