//
//  SecretWordViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 18.05.2024.
//

//Task 6

import UIKit
import Foundation

class SecretWordViewController: UIViewController {
    
    private let secretWord: String
    
    
    var currentState = SecretWordModel() {
        didSet {
            self.emojiLabel.text = currentState.currentEmoji
            self.phraseLabel.text = currentState.currentPhrase
        }
    }
    
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.currentState.currentEmoji
        label.font = .systemFont(ofSize: 100)
        
        return label
    }()
    
    private lazy var phraseLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.currentState.currentPhrase
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var textField: UITextFieldWithPadding = {
        let placeholder = String(localized: "Guess the word...")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)        
        return textField
    }()
    
    private lazy var checkButton = CustomButton(customTitle: String(localized: "Check")) { [unowned self] in
        guard let word = textField.text else { return }
        if word.lowercased() == self.secretWord.lowercased() {
            self.currentState = SecretWordModel(guessed: true)
        } else {
            self.currentState = SecretWordModel(guessed: false)
        }
    }



    // MARK: - Lifecycle
    init(secretWord: String) {
        self.secretWord = secretWord.lowercased()
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.secretWord = "default".lowercased()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.addSubview(emojiLabel)
        view.addSubview(phraseLabel)
        view.addSubview(textField)
        view.addSubview(checkButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            emojiLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            phraseLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 15),
            phraseLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            phraseLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: phraseLabel.bottomAnchor, constant: 30),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            checkButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            checkButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            checkButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -30),
            checkButton.heightAnchor.constraint(equalToConstant: 50)
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
