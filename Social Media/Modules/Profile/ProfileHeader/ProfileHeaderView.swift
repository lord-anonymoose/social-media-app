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
    
    lazy var userImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: me.login))
                
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
                        
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        
        userName.text = me.login
        userName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userName.textColor = textColor
        userName.sizeToFit()
                
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
        contentView.backgroundColor = backgroundColor
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

        userImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets.top).offset(16)
            make.left.equalTo(self.safeAreaInsets.left).offset(16)
            make.height.width.equalTo(userImage.layer.cornerRadius * 2)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets.top).offset(16)
            make.left.equalTo(userImage.snp.right).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).inset(-16)
        }
        
        userStatus.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(16)
            make.left.equalTo(userImage.snp.right).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).offset(-16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(userStatus.snp.bottom).offset(40)
            make.left.equalTo(self.safeAreaInsets.left).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).offset(-16)
            make.height.equalTo(32)
        }
        
        showStatusButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.left.equalTo(self.safeAreaInsets.left).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).offset(-16)
        }
        
        NSLayoutConstraint.activate([bottomAnchor])
    }
}
