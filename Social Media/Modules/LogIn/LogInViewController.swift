//
//  logInViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase



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
        let imageView = UIImageView(image: UIImage(named: "appLogo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var logInInputContainer = LoginInputContainer()
    
    private lazy var loginTextField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "Username")
        textField.textColor = .textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = .accentColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.masksToBounds = true
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.text = "strawberry_moose@media.com"
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "Password")
        textField.isSecureTextEntry = true
        textField.textColor = .textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = .accentColor
        textField.layer.masksToBounds = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.text = "123456"
        
        return textField
    }()
    
    private lazy var logInButton = CustomButton(customTitle: String(localized: "Log In")) { [unowned self] in
        
        startLoginOperation()

        Task {
            do {
                try await FirebaseService.login(email: loginTextField.text ?? "", password: passwordTextField.text ?? "")
                stopLoginOperation()
                if let navigationController = self.navigationController {
                    let coordinator = MainCoordinator(navigationController: navigationController)
                    coordinator.start()
                }
            } catch {
                stopLoginOperation()
                showErrorAlert(description: error.localizedDescription)
            }
        }
        
        
        /*
        Task {
            do {
                try await FirebaseService.resetPassword(email: loginTextField.text ?? "")
                stopLoginOperation()
            } catch {
                showErrorAlert(description: error.localizedDescription)
            }
        }*/
    }
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleShowPassword), for: .touchUpInside)
        button.tintColor = .systemGray
        
        return button
    }()
    
    private lazy var loginIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        
        return activityIndicator
    }()
    
    private lazy var signUpButton = CustomButton(customTitle: String(localized: "Not a member yet? Sign up!"), customBackgroundColor: .secondaryColor ,action: {
        
        print("Started action")
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showSignUpViewController()
        }
    })
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
        setupScrollViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.loginIndicator.stopAnimating()
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    
    
    // MARK: - Actions
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = 0.0
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toggleShowPassword() {
        if showPasswordButton.image(for: .normal) == UIImage(systemName: "eye") {
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(appLogo)
        
        contentView.addSubview(logInInputContainer)
        logInInputContainer.addSubview(loginTextField)
        logInInputContainer.addSubview(passwordTextField)
        logInInputContainer.addSubview(showPasswordButton)
        
        contentView.addSubview(logInButton)
        contentView.addSubview(loginIndicator)
        contentView.addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let bottom = view.safeAreaLayoutGuide.layoutFrame.height
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
        
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalToConstant: bottom),
        ])
    }
    
    private func setupScrollViewConstraints() {
        
        let centerY = view.safeAreaLayoutGuide.layoutFrame.height / 2
        
        NSLayoutConstraint.activate([
            logInInputContainer.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 100),
        
            loginTextField.topAnchor.constraint(equalTo: logInInputContainer.topAnchor, constant: 0),
            loginTextField.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: -50),
            loginTextField.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            loginTextField.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 0),
            passwordTextField.bottomAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor, constant: 0),
            passwordTextField.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor, constant: 0),
            
            showPasswordButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            showPasswordButton.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
        
            appLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            appLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appLogo.heightAnchor.constraint(equalToConstant: 100),
            appLogo.widthAnchor.constraint(equalToConstant: 100),
        
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        
            logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            loginIndicator.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor),
            loginIndicator.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor, constant: -16),
            loginIndicator.widthAnchor.constraint(equalToConstant: 50),
            loginIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func startLoginOperation() {
        self.logInButton.setBackgroundColor(.systemGray, forState: .normal)
        
        self.loginIndicator.startAnimating()
        self.loginIndicator.isHidden = false
        
        self.loginTextField.isUserInteractionEnabled = false
        self.passwordTextField.isUserInteractionEnabled = false
    }
    
    private func stopLoginOperation() {
        self.logInButton.setBackgroundColor(.accentColor, forState: .normal)
        
        self.loginIndicator.stopAnimating()
        self.loginIndicator.isHidden = true
        
        self.loginTextField.isUserInteractionEnabled = true
        self.passwordTextField.isUserInteractionEnabled = true
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
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
