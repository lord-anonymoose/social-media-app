//
//  ResetPasswordViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 05.09.2024.
//

import Foundation
import UIKit



final class ResetPasswordViewController: UIViewController {
    
    
    
    // MARK: - Subviews
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let placeholder = String(localized: "Email")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        return textField
    }()
    
    
    // MARK: - Lifecycle
    
    
    
    // MARK: - Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    
    // MARK: - Private
    private func setupUI() {
        
    }
    
    private func addSubviews() {
        
    }
    
    private func setupConstraints() {
        
    }
}
