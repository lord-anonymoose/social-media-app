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
    
    private lazy var logInInputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        return view
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
        button.addTarget(self, action: #selector(loggedIn), for: .touchUpInside)
        return button
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        view.addSubview(vkLogo)
        view.addSubview(logInButton)
        logInInputContainer.addSubview(loginInput)
        logInInputContainer.addSubview(passwordInput)
        view.addSubview(logInInputContainer)
    }
    
    private func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            vkLogo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120),
            vkLogo.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            vkLogo.heightAnchor.constraint(equalToConstant: 100),
            vkLogo.widthAnchor.constraint(equalToConstant: 100),
            
            logInInputContainer.topAnchor.constraint(equalTo: vkLogo.bottomAnchor, constant: 120),
            logInInputContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInInputContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 100),
            
            loginInput.topAnchor.constraint(equalTo: logInInputContainer.topAnchor, constant: 0),
            loginInput.heightAnchor.constraint(equalToConstant: 50),
            loginInput.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginInput.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.heightAnchor.constraint(equalToConstant: 50),
            passwordInput.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordInput.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logInButton.topAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func loggedIn(_ sender: UIButton) {
        let profileViewController = ProfileViewController()

        if let navigationController = navigationController {
            navigationController.setViewControllers([profileViewController], animated: true)
        }
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.items?[1].image = UIImage(systemName: "person.crop.circle")
            tabBarController.tabBar.items?[1].title = nil
        }
        
    }
}
