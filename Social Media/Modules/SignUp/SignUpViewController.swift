//
//  SignUpViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 29.06.2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore



final class SignUpViewController: UIViewController {
    
    
    
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
        contentView.accessibilityIdentifier = "contentView"

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
        
        label.text = "Welcome on board!".localized
        label.font = .systemFont(ofSize: 30)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var logInInputContainer = UILoginInputContainer()
    
    private lazy var loginInput: UITextFieldWithPadding = {
        let placeholder = "Email".localized
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        return textField
    }()
    
    private lazy var firstPasswordInput: UITextFieldWithPadding = {
        let placeholder = "Password".localized
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: true)
        return textField
    }()
    
    private lazy var secondPasswordInput: UITextFieldWithPadding = {
        let placeholder = "Repeat password".localized
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: true)
        return textField
    }()
    
    private lazy var signUpButton = UICustomButton(customTitle: "Sign Up".localized, action: { [self] in
        self.startSignupProcess()
        
        FirebaseService.shared.checkIfEmailIsRegistered(email: self.loginInput.text ?? "") { isRegistered in
            if isRegistered {
                let title = "Error!".localized
                let description = "User with this email already exists!".localized
                self.showAlert(title: title, description: description)
                self.finishSignupProcess()
                return
            }
        }
        
        Task {
            do {
                try await FirebaseService.shared.signUp(email: self.loginInput.text ?? "",
                                                 password1: self.firstPasswordInput.text ?? "",
                                                 password2: self.secondPasswordInput.text ?? "")
                self.finishSignupProcess()
                
                let title = "Check your mailbox!".localized
                let message = "We have sent you an email to confirm your address.".localized
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (button) in
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }))
                present(alert, animated: true, completion: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    })
    
    private lazy var signupIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginInput.delegate = self
        self.firstPasswordInput.delegate = self
        self.secondPasswordInput.delegate = self
        
        setupUI()
        addSubviews()
        setupConstraints()
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
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(wavingHandLabel)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(logInInputContainer)
        logInInputContainer.addSubview(loginInput)
        logInInputContainer.addSubview(firstPasswordInput)
        logInInputContainer.addSubview(secondPasswordInput)
        contentView.addSubview(signUpButton)
        contentView.addSubview(signupIndicator)
    }
    
    private func setupConstraints() {
        let centerY = view.safeAreaLayoutGuide.layoutFrame.height / 2

        self.makeScrollable()

        NSLayoutConstraint.activate([
            wavingHandLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            wavingHandLabel.heightAnchor.constraint(equalToConstant: 100),
            wavingHandLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
            welcomeLabel.topAnchor.constraint(equalTo: wavingHandLabel.bottomAnchor, constant: 25),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
            logInInputContainer.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            logInInputContainer.heightAnchor.constraint(equalToConstant: 150),
        
            loginInput.topAnchor.constraint(equalTo: logInInputContainer.topAnchor),
            loginInput.heightAnchor.constraint(equalToConstant: 50),
            loginInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            loginInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor),
        
            firstPasswordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor),
            firstPasswordInput.heightAnchor.constraint(equalToConstant: 50),
            firstPasswordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            firstPasswordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor),

            secondPasswordInput.topAnchor.constraint(equalTo: firstPasswordInput.bottomAnchor),
            secondPasswordInput.heightAnchor.constraint(equalToConstant: 50),
            secondPasswordInput.leadingAnchor.constraint(equalTo: logInInputContainer.leadingAnchor),
            secondPasswordInput.trailingAnchor.constraint(equalTo: logInInputContainer.trailingAnchor),
        
            signUpButton.topAnchor.constraint(equalTo: secondPasswordInput.bottomAnchor, constant: 50),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        
            signupIndicator.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
            signupIndicator.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor, constant: -25),
            signupIndicator.widthAnchor.constraint(equalToConstant: 50),
            signupIndicator.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    /*
    func showVerificationViewController() {
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showVerificationViewController()
        }
    }
    */
    
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
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    private func startSignupProcess() {
        self.signUpButton.isUserInteractionEnabled = false
        self.loginInput.isUserInteractionEnabled = false
        self.firstPasswordInput.isUserInteractionEnabled = false
        self.secondPasswordInput.isUserInteractionEnabled = false
        
        self.signupIndicator.isHidden = false
        self.signupIndicator.startAnimating()
        
    }
    
    private func finishSignupProcess() {
        self.signUpButton.isUserInteractionEnabled = true
        self.loginInput.isUserInteractionEnabled = true
        self.firstPasswordInput.isUserInteractionEnabled = true
        self.secondPasswordInput.isUserInteractionEnabled = true
        
        self.signupIndicator.stopAnimating()
        self.signupIndicator.isHidden = true
    }
}
