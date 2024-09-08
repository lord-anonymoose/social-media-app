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
    
    private lazy var emailTextField: UITextField = {
        let placeholder = String(localized: "Email")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        return textField
    }()
    
    private lazy var sendResetLinkButton = UICustomButton(customTitle: String(localized: "Send Reset Link"), customBackgroundColor: .secondaryColor ,action: {
        self.sendResetLink()
    })
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
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

        NSLayoutConstraint.activate([
        
        ])
    }
    
    private func sendResetLink() {
        Task {
            do {
                try await FirebaseService.resetPassword(email: self.emailTextField.text ?? "")
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
