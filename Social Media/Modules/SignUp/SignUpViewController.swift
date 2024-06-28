//
//  SignUpViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 29.06.2024.
//

import UIKit
import Foundation

class SignUpViewController: UIViewController {
    
    
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.isUserInteractionEnabled = true
                
        return contentView
    }()
    
    private lazy var wavingHandLabel: UILabel = {
        let label = UILabel()
        
        label.text = "👋"
        label.font = .systemFont(ofSize: 100)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var welcomeLabel: UILabel = {
       let label = UILabel()
        
        label.text = "Welcome on board!"
        label.font = .systemFont(ofSize: 30)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var logInInputContainer = LoginInputContainer()
    
    private lazy var loginInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var firstPasswordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var secondPasswordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var signUpButton = CustomButton(customTitle: "Sign Up", action: {
        
    })
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Actions
    @objc func sampleFunction() {
        //
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = backgroundColor
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
                
        contentView.addSubview(signUpButton)
        contentView.addSubview(logInInputContainer)
        contentView.addSubview(wavingHandLabel)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(logInInputContainer)
        logInInputContainer.addSubview(loginInput)
        logInInputContainer.addSubview(firstPasswordInput)
        logInInputContainer.addSubview(secondPasswordInput)
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -50),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logInInputContainer.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -25),
            logInInputContainer.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            logInInputContainer.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            loginInput.topAnchor.constraint(equalTo: logInInputContainer.topAnchor),
            loginInput.heightAnchor.constraint(equalToConstant: 50),
            loginInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            loginInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            firstPasswordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor),
            firstPasswordInput.heightAnchor.constraint(equalToConstant: 50),
            firstPasswordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            firstPasswordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            secondPasswordInput.topAnchor.constraint(equalTo: firstPasswordInput.bottomAnchor),
            secondPasswordInput.heightAnchor.constraint(equalToConstant: 50),
            secondPasswordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            secondPasswordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.bottomAnchor.constraint(equalTo: logInInputContainer.topAnchor, constant: -100),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            wavingHandLabel.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -25),
            wavingHandLabel.heightAnchor.constraint(equalToConstant: 100),
            wavingHandLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
        ])
        
    }
}
