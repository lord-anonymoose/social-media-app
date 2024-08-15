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
        
        label.text = String(localized: "Welcome on board!")
        label.font = .systemFont(ofSize: 30)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var logInInputContainer = LoginInputContainer()
    
    private lazy var loginInput: UITextFieldWithPadding = {
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
        
        return textField
    }()
    
    private lazy var firstPasswordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "Password")
        textField.isSecureTextEntry = true
        textField.textColor = .textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = .accentColor
        textField.layer.masksToBounds = true
        textField.textContentType = UITextContentType(rawValue: "")
        
        // Disabling Automatic Password Suggestion
        textField.textContentType = .none
        textField.isSecureTextEntry = false
        textField.keyboardType = .default
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var secondPasswordInput: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = String(localized: "Repeat Password")
        textField.isSecureTextEntry = true
        textField.textColor = .textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = .accentColor
        textField.layer.masksToBounds = true
        textField.textContentType = UITextContentType(rawValue: "")

        // Disabling Automatic Password Suggestion
        textField.textContentType = .none
        textField.isSecureTextEntry = false
        textField.keyboardType = .default
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var signUpButton = CustomButton(customTitle: String(localized: "Sign Up"), action: { [self] in
        self.startSignupProcess()
        guard let email = self.loginInput.text else {
            self.showErrorAlert(description: CheckerError.emptyEmail.localizedDescription)
            finishSignupProcess()
            return
        }
        
        if !email.contains("@media.com") {
            self.showErrorAlert(description: CheckerError.invalidEmail.localizedDescription)
            finishSignupProcess()
            return
        }
                
        guard let password = self.firstPasswordInput.text else {
            self.showErrorAlert(description: CheckerError.emptyPassword.localizedDescription)
            self.finishSignupProcess()
            return
        }
        
        if !self.checkMatchingPasswords() {
            self.showErrorAlert(description: CheckerError.passwordsNotMatching.localizedDescription)
            finishSignupProcess()
            return
        }
        
        let login = email.replacingOccurrences(of: "@media.com", with: "")
        let checkerService = CheckerService()
        checkerService.getUser(username: login) {user in
            if let result = user {
                self.showErrorAlert(description: CheckerError.userExists.localizedDescription)
                return
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.showErrorAlert(description: error.localizedDescription)
                        self.finishSignupProcess()
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                self.showErrorAlert(description: error.localizedDescription)
                                self.finishSignupProcess()
                            } else {
                                checkerService.addUserToDatabase(login: login, name: login)
                                if let navigationController = self.navigationController {
                                    let coordinator = ProfileCoordinator(navigationController: navigationController)
                                    let newUser = User(login: login, name: login)
                                    coordinator.authenticate(user: newUser)
                                    coordinator.start()
                                    self.finishSignupProcess()
                                }
                            }
                        }
                    }
                }
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
        let safeAreaGuide = view.safeAreaLayoutGuide
        let bottom = view.safeAreaLayoutGuide.layoutFrame.height
        let centerY = view.safeAreaLayoutGuide.layoutFrame.height / 2

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
            contentView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: bottom),
        ])
        
        NSLayoutConstraint.activate([
            wavingHandLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            wavingHandLabel.heightAnchor.constraint(equalToConstant: 100),
            wavingHandLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: wavingHandLabel.bottomAnchor, constant: 25),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            logInInputContainer.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
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
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            signupIndicator.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
            signupIndicator.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor, constant: -25),
            signupIndicator.widthAnchor.constraint(equalToConstant: 50),
            signupIndicator.heightAnchor.constraint(equalToConstant: 50)
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
    
    private func checkMatchingPasswords() -> Bool {
        if let firstPassword = firstPasswordInput.text {
            if firstPassword == "" {
                showErrorAlert(description: CheckerError.emptyPassword.localizedDescription)
                return false
            }
            
            if let secondPassword = secondPasswordInput.text {
                if secondPassword == "" {
                    showErrorAlert(description: CheckerError.emptyRepeatPassword.localizedDescription)
                    return false
                }
                
                if firstPassword == secondPassword {
                    return true
                } else {
                    showErrorAlert(description: CheckerError.passwordsNotMatching.localizedDescription)
                    return false
                }
            }
        }
        return false
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    private func startSignupProcess() {
        //self.signUpButton.setBackgroundColor(.systemGray, forState: .normal)
        
        self.signUpButton.isUserInteractionEnabled = false
        self.loginInput.isUserInteractionEnabled = false
        self.firstPasswordInput.isUserInteractionEnabled = false
        self.secondPasswordInput.isUserInteractionEnabled = false
        
        self.signupIndicator.isHidden = false
        self.signupIndicator.startAnimating()
        
    }
    
    private func finishSignupProcess() {
        //self.signUpButton.setBackgroundColor(.accentColor, forState: .normal)
        
        self.signUpButton.isUserInteractionEnabled = true
        self.loginInput.isUserInteractionEnabled = true
        self.firstPasswordInput.isUserInteractionEnabled = true
        self.secondPasswordInput.isUserInteractionEnabled = true
        
        self.signupIndicator.stopAnimating()
        self.signupIndicator.isHidden = true
    }
}
