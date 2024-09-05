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



final class LogInViewController: UIViewController {
    
    private var tryCount = 0

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
    
    private lazy var loginInputContainer = LoginInputContainer()
    
    private lazy var loginTextField: UITextFieldWithPadding = {
        let placeholder = String(localized: "Email")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        return textField
    }()
    
    private lazy var passwordTextField: UITextFieldWithPadding = {
        let placeholder = String(localized: "Password")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: true)
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
                    coordinator.showMainScreen()
                }
            } catch {
                stopLoginOperation()
                showErrorAlert(description: error.localizedDescription)
                self.tryCount += 1
                if self.tryCount > 2 {
                    self.resetPasswordButton.isHidden = false
                }
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
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Forgot your password? Reset it here.", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
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
        self.tryCount = 0
        self.resetPasswordButton.isHidden = true
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
    
    @objc func showPasswordButtonTapped() {
        if showPasswordButton.image(for: .normal) == UIImage(systemName: "eye") {
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func resetPasswordButtonTapped() {
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showResetPasswordViewController()
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
        
        contentView.addSubview(loginInputContainer)
        loginInputContainer.addSubview(loginTextField)
        loginInputContainer.addSubview(passwordTextField)
        loginInputContainer.addSubview(showPasswordButton)
        
        contentView.addSubview(resetPasswordButton)
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
            loginInputContainer.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY),
            loginInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            loginInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            loginInputContainer.heightAnchor.constraint(equalToConstant: 100),
        
            loginTextField.topAnchor.constraint(equalTo: loginInputContainer.topAnchor, constant: 0),
            loginTextField.bottomAnchor.constraint(equalTo: loginInputContainer.bottomAnchor, constant: -50),
            loginTextField.leadingAnchor.constraint(equalTo: loginInputContainer.leadingAnchor, constant: 0),
            loginTextField.trailingAnchor.constraint(equalTo: loginInputContainer.trailingAnchor, constant: 0),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 0),
            passwordTextField.bottomAnchor.constraint(equalTo: loginInputContainer.bottomAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: loginInputContainer.leadingAnchor, constant: 0),
            passwordTextField.trailingAnchor.constraint(equalTo: loginInputContainer.trailingAnchor, constant: 0),
            
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
            loginIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            resetPasswordButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -10),
            //resetPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            resetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            resetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
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
