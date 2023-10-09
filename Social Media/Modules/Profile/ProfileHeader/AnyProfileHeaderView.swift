//
//  AnyProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.07.2023.
//

// A UIView to represent any user profile except for the current user
// Following code is yet to be refactored

import UIKit
import SnapKit

class AnyProfileHeaderView: UITableViewHeaderFooterView {
    
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
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        addSuviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        addSuviews()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    // MARK: - Private
    private func setupUI() {
        contentView.backgroundColor = secondaryColor
    }
        
    private func addSuviews() {
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(userStatus)
    }
        
    private func setupConstraints() {

        let safeAreaLayoutGuide = contentView.safeAreaLayoutGuide
            
            // this will avoid auto-layout complaints
        let bottomAnchor = userImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        bottomAnchor.priority = .required - 1
            
        userImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets.top).inset(16)
            make.left.equalTo(self.safeAreaInsets.left).inset(16)
            make.height.width.equalTo(userImage.layer.cornerRadius * 2)
        }
        
        userName.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets.top).inset(16)
            make.left.equalTo(userImage.snp.right).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).inset(-16)
        }
        
        userStatus.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(16)
            make.left.equalTo(userImage.snp.right).offset(16)
            make.right.equalTo(self.safeAreaInsets.right).offset(-16)
        }
    }
}
