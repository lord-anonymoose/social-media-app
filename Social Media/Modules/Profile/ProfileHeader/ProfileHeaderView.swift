//
//  ProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//

// Adding comment just to check

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Subviews
    
    private var statusText: String = ""
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: me.login))
                
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        
        userName.text = me.login
        userName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userName.textColor = .black
        userName.sizeToFit()
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        return userName
    }()
    
    private lazy var userStatus: UILabel = {
        let userStatus = UILabel()
                
        userStatus.text = "Waiting for something..."
        userStatus.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        userStatus.textColor = .gray
        userStatus.sizeToFit()
        userStatus.lineBreakMode = .byWordWrapping
        userStatus.textAlignment = .left
        
        userStatus.translatesAutoresizingMaskIntoConstraints = false
        
        return userStatus
    }()
    
    private lazy var showStatusButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = accentColor
                
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 12
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var textField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding()
                
        textField.placeholder = "Hello, world"
        textField.backgroundColor = .white
        
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        
        textField.layer.cornerRadius = 12
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        
        return textField
    }()

    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSuviews()
        setupConstraints()
        changeBackgroundColor()
    }
     
    // MARK: - Actions
    
    @objc func buttonPressed(_ sender: UIButton) {
        userStatus.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSuviews()
        setupConstraints()
        changeBackgroundColor()
    }
    
    // MARK: - Private
    
    func changeBackgroundColor() {
       #if DEBUG
        contentView.backgroundColor = accentColor
       #else
        contentView.backgroundColor = secondaryColor
       #endif
    }
        
    private func addSuviews() {
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(userStatus)
        contentView.addSubview(textField)
        contentView.addSubview(showStatusButton)
    }
        
    private func setupConstraints() {

        let safeAreaLayoutGuide = contentView.safeAreaLayoutGuide
            
        let bottomAnchor = showStatusButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        bottomAnchor.priority = .required - 1
            
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor
                                               , constant: 16),
            userImage.widthAnchor.constraint(equalToConstant: userImage.layer.cornerRadius * 2),
            userImage.heightAnchor.constraint(equalToConstant: userImage.layer.cornerRadius * 2),
            
            userName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        
            userStatus.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userStatus.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),

            textField.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 48),
            textField.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 32),
        
            showStatusButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            showStatusButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            bottomAnchor
        ])
    }
}
