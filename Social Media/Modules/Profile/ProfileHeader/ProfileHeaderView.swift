//
//  ProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//



import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    

    // MARK: - Subviews
    
    public var user: User? {
        didSet {
            nameLabel.text = user?.name ?? "Unknown"
            statusLabel.text = user?.status ?? String(localized: "Type new status")
            setupConstraints()
        }
    }
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultUserImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let userName = UILabel()
        
        userName.text = "defaultUserImage"
        userName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userName.textColor = .textColor
        userName.sizeToFit()
        
        userName.translatesAutoresizingMaskIntoConstraints = false

        return userName
    }()
    
    private lazy var statusLabel: UILabel = {
        let userStatus = UILabel()
                
        userStatus.text = String(localized: "Waiting for something...")
        userStatus.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        userStatus.textColor = .gray
        userStatus.sizeToFit()
        userStatus.lineBreakMode = .byWordWrapping
        userStatus.textAlignment = .left
                
        userStatus.translatesAutoresizingMaskIntoConstraints = false

        return userStatus
    }()

    
    lazy var logoutButton: UISymbolButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.forward", withConfiguration: config)!
        let button = UISymbolButton(image: image, tintColor: .systemRed)
        return button
    }()

    lazy var settingsButton: UISymbolButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        let image = UIImage(systemName: "pencil.circle", withConfiguration: config)!
        let button = UISymbolButton(image: image, tintColor: .systemGray)
        return button
    }()
    
    private lazy var statusTextField: UITextFieldWithPadding = {
        let placeholder = String(localized: "Hello, world!")
        let textField = UITextFieldWithPadding(placeholder: placeholder, isSecureTextEntry: false)
        textField.delegate = self

        return textField
    }()

    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        changeBackgroundColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupConstraints()
        changeBackgroundColor()
    }
    
     
    
    // MARK: - Private
    
    func changeBackgroundColor() {
       #if DEBUG
        contentView.backgroundColor = .systemBackground
       #else
        contentView.backgroundColor = .secondaryColor
       #endif
    }
        
    func addSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(logoutButton)
        contentView.addSubview(settingsButton)
    }
        
    func setupConstraints() {
        
        let safeAreaLayoutGuide = contentView.safeAreaLayoutGuide

        let bottomAnchor = userImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        bottomAnchor.priority = .required - 1

        
        NSLayoutConstraint.activate([
            
            userImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userImageView.heightAnchor.constraint(equalToConstant: 90),
            userImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            nameLabel.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -16),
            
            logoutButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 31),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 31),
            
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            settingsButton.heightAnchor.constraint(equalTo: logoutButton.heightAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalTo: logoutButton.widthAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            statusLabel.heightAnchor.constraint(equalToConstant: 32),
            statusLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            statusLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
        
        NSLayoutConstraint.activate([bottomAnchor])

    }
}
