//
//  logInViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import UIKit
import Foundation

class LogInViewController: UIViewController {

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
    
    private lazy var appLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppLogo"))
        
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

    private lazy var loginInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
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
        textField.layer.masksToBounds = true
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let backgroundImage = UIImage(named: "greenPixel")
        let backgroundImageTinted = backgroundImage?.image(alpha: 0.8)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setBackgroundImage(backgroundImageTinted, for: .selected)
        button.setBackgroundImage(backgroundImageTinted, for: .highlighted)
        button.setBackgroundImage(backgroundImageTinted, for: .disabled)
        
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
        
        button.isUserInteractionEnabled = true

        button.addTarget(self, action: #selector(loggedIn), for: .touchUpInside)

        return button
    }()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Actions

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
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = 0.0
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    // MARK: - Private
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(appLogo)
        
        contentView.addSubview(logInInputContainer)
        logInInputContainer.addSubview(loginInput)
        logInInputContainer.addSubview(passwordInput)
        
        contentView.addSubview(logInButton)
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
    }
    
    private func setupContentOfScrollView() {
        NSLayoutConstraint.activate([
            appLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            appLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appLogo.heightAnchor.constraint(equalToConstant: 100),
            appLogo.widthAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            logInInputContainer.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 120),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            loginInput.topAnchor.constraint(equalTo: logInInputContainer.topAnchor, constant: 0),
            loginInput.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: -50),
            loginInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            loginInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0),
    
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 0),
            passwordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            passwordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willShowKeyboard(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willHideKeyboard(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
    private func removeKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self)
    }
}