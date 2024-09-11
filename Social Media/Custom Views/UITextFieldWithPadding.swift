//
//  UITextFieldWithPadding.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



final class UITextFieldWithPadding: UITextField {
    
    // MARK: - Subviews
    
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 0
    )
    
    // MARK: - Lifecycle
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    init(placeholder: String, isSecureTextEntry: Bool) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        if isSecureTextEntry {
            self.isSecureTextEntry = true
        }
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        //textField.placeholder = String(localized: "Username")
        self.textColor = .textColor
        self.font = .systemFont(ofSize: 16)
        self.tintColor = .accentColor
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        //self.keyboardType = .emailAddress
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        //self.text = "strawberry_moose@media.com"
    }
}
