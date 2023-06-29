//
//  logInViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import UIKit
import Foundation

class LogInViewController: UIViewController {
    
    private lazy var vkLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "vkLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemGray6
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let backgroundImage = UIImage(named: "bluePixel")
        let backgroundImageTinted = backgroundImage?.image(alpha: 0.8)
        
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setBackgroundImage(backgroundImageTinted, for: .selected)
        button.setBackgroundImage(backgroundImageTinted, for: .highlighted)
        button.setBackgroundImage(backgroundImageTinted, for: .disabled)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        //button.addTarget(self, action: #selector(rateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(vkLogo)
        view.addSubview(logInButton)
        view.addSubview(inputContainerView)
        
        inputContainerView.addSubview(loginInput)
        inputContainerView.addSubview(passwordInput)
        
        NSLayoutConstraint.activate([
            vkLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            vkLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            vkLogo.heightAnchor.constraint(equalToConstant: 100),
            vkLogo.widthAnchor.constraint(equalToConstant: 100),
            
            inputContainerView.topAnchor.constraint(equalTo: vkLogo.bottomAnchor, constant: 120),
            inputContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            inputContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            loginInput.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0),
            loginInput.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 0),
            loginInput.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: 0),
            loginInput.heightAnchor.constraint(equalToConstant: 50),
            
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 0),
            passwordInput.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 0),
            passwordInput.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: 0),
            
            logInButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
