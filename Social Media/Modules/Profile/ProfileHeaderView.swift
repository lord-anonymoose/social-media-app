//
//  ProfileHeaderView.swift
//  iOS_UI_HW3
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = ""
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: me.login))
                
        imageView.layer.cornerRadius = 48
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        
        userName.text = me.login
        userName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userName.textColor = .black
        userName.sizeToFit()
        
        return userName
    }()
    
    private lazy var userStatus: UILabel = {
        let userStatus = UILabel()
                
        userStatus.text = "Waiting for something..."
        userStatus.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        userStatus.textColor = .gray
        userStatus.sizeToFit()
        
        return userStatus
    }()
    
    private lazy var showStatusButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .blue
                
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 4
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addSuviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        addSuviews()
    }
    
    private func setupUI() {
        backgroundColor = .lightGray
    }
    
    private func addSuviews() {
        addSubview(userImage)
        addSubview(userName)
        addSubview(userStatus)
        addSubview(showStatusButton)
        addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.frame = CGRect(
            x: bounds.minX + 10,
            y: bounds.minY + 16,
            width: userImage.layer.cornerRadius * 2,
            height: userImage.layer.cornerRadius * 2
        )
        
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 3
        
        userName.frame = CGRect(
            x: bounds.midX - userName.frame.width/2,
            y: bounds.minY + 16,
            width: userName.frame.width,
            height: userName.frame.height
        )
        userStatus.frame = CGRect(
            x: userName.frame.origin.x,
            y: userName.frame.maxY + 8,
            width: userStatus.frame.width,
            height: userStatus.frame.height
        )
        
        textField.frame = CGRect(
            x: userStatus.frame.origin.x,
            y: userStatus.frame.maxY + 8,
            width: bounds.maxX - 16 - userStatus.frame.origin.x,
            height: 40
        )
        
        showStatusButton.frame = CGRect(
            x: bounds.minX + 16,
            y: userImage.frame.maxY + 16,
            width: bounds.maxX - 16 - bounds.minY - 16,
            height: 50
        )
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        userStatus.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text
        }
    }
}
