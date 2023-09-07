//
//  AnyProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.07.2023.
//

// A UIView to represent any user profile except for the current user

import UIKit

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
        //userStatus.numberOfLines = 2
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
            userStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
