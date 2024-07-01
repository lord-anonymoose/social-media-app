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
        textField.placeholder = "Repeat Password"
        textField.isSecureTextEntry = true
        textField.textColor = textColor
        textField.font = .systemFont(ofSize: 16)
        textField.tintColor = accentColor
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
    
    private lazy var signUpButton = CustomButton(customTitle: "Sign Up", action: {
        if self.checkMatchingPasswords() {
            print("Success")
        }
    })
    
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
        view.backgroundColor = backgroundColor
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
            logInInputContainer.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 150),
            logInInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            signUpButton.topAnchor.constraint(equalTo: logInInputContainer.bottomAnchor, constant: 25),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
                showErrorAlert(message: "First password field is empty!")
                return false
            }
            
            if let secondPassword = secondPasswordInput.text {
                if secondPassword == "" {
                    showErrorAlert(message: "Second password field is empty!")
                    return false
                }
                
                if firstPassword == secondPassword {
                    print("Success")
                    return true
                } else {
                    showErrorAlert(message: "Passwords don't match!")
                    print("Fail")
                    return false
                }
            }
        }
        return false
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
}
