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
        let imageView = UIImageView(image: UIImage(named: "hipsterCat"))
        imageView.contentMode = .scaleAspectFit
        
        // Making UIImageView round manually
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = "Hipster Cat"
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .lightGray
        
        addSubview(userImage)
        addSubview(userName)
        addSubview(userStatus)
        addSubview(showStatusButton)
        addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.frame = CGRect(
            x: bounds.minX + 16,
            y: bounds.minY + 16,
            width: 120,
            height: 120
        )
        
        // Making image round (legacy solution)
        //userImage.layer.cornerRadius = userImage.frame.size.width / 2
        //userImage.clipsToBounds = true
        
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 3
        
        userName.frame = CGRect(
            x: bounds.midX - userName.frame.width/2,
            y: bounds.minY + 27,
            width: userName.frame.width,
            height: userName.frame.height
        )
        
        showStatusButton.frame = CGRect(
            x: bounds.minX + 16,
            y: userImage.frame.maxY + 16,
            width: bounds.maxX - 16 - bounds.minY - 16,
            height: 50
        )

        userStatus.frame = CGRect(
            x: userName.frame.origin.x,
            y: textField.frame.origin.y - 16 - userStatus.frame.height / 2,
            width: userStatus.frame.width,
            height: userStatus.frame.height
        )
        
        textField.frame = CGRect(
            x: userStatus.frame.origin.x,
            y: showStatusButton.frame.origin.y - 56,
            width: bounds.maxX - 16 - userStatus.frame.origin.x,
            height: 40
        )
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        userStatus.text = statusText
        print(userStatus.text ?? "No User Status")
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text
        }
    }
}
