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

extension UIViewController {
    public func makeScrollable() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        guard let scrollView = view.subviews.compactMap({ $0 as? UIScrollView }).first else {
            return
        }
        
        guard let contentView = scrollView.subviews.first(where: { $0.accessibilityIdentifier == "contentView"}) else {
            return
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Create height constraint with lower priority
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow  // Set priority
        contentViewHeightConstraint.isActive = true  // Activate the constraint
        /*
        if let scrollView = view.subviews.compactMap({ $0 as? UIScrollView }).first {
            scrollView.contentInset.bottom = keyboardFrame.height
        }*/
    }
}
