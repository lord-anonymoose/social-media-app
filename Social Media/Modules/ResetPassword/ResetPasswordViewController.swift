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
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var emailTextField: UITextFieldWithPadding = {
        let placeholder = String(localized: "Email")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        textField.layer.cornerRadius = 10.0
        return textField
    }()
    
    private lazy var sendResetLinkButton = UICustomButton(customTitle: String(localized: "Send Reset Link"), customBackgroundColor: .secondaryColor ,action: {
        self.sendResetLink()
    })
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        contentView.addSubview(textLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(sendResetLinkButton)
    }
    
    private func setupConstraints() {
        
        self.makeScrollable()
        
        let centerY = view.safeAreaLayoutGuide.layoutFrame.height / 2

        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: centerY - 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25),
            
            sendResetLinkButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 200),
            sendResetLinkButton.heightAnchor.constraint(equalToConstant: 50),
            sendResetLinkButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            sendResetLinkButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25)
        ])
    }
    
    private func sendResetLink() {
        Task {
            do {
                try await FirebaseService.shared.resetPassword(email: self.emailTextField.text ?? "")
                let title = String(localized: "Check your mailbox!")
                let message = String(localized: "We have sent you an email with instructions for resetting your password")
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (button) in
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }))
                present(alert, animated: true, completion: nil)
            } catch {
                let title = String(localized: "Error!")
                showAlert(title: title, description: error.localizedDescription)
            }
        }
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
