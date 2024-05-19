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
    
    
    var currentState = SecretWordState()
    
    
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
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Guess the word..."
        textField.tintColor = accentColor
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor

        return textField
    }()
    
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

        print(currentState.currentEmoji)
        print(currentState.currentPhrase)
        print("-----")
    }
    
    private func addSubviews() {
        view.addSubview(emojiLabel)
        view.addSubview(phraseLabel)
        view.addSubview(textField)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 100),
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
            textField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -30),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func check(word: String) {
        
    }
}
