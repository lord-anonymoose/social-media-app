//
//  ProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//



import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    
    var timeLeft: Int = 60
    var timer: Timer?
    
    //var image: UIImage?
    
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
        imageView.image = UIImage(named: "default")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let userName = UILabel()
        
        userName.text = "default"
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
    
    private lazy var setStatusButton = UICustomButton(customTitle: String(localized: "Set Status")) {[unowned self] in
        let newStatus = statusTextField.text ?? ""
        statusLabel.text = newStatus
        if self.user != nil {
        }
        
        /*
        if let id = FirebaseService.shared.currentUserID() {
            Task {
                do {
                    try await FirebaseService.shared.setUserStatus(newStatus: newStatus, for: id)
                    statusTextField.text = ""
                    startTimer()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
         */
    }
    
    
    /*
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        let image = UIImage
        return button
    }()
    */
    
    //private lazy var settingsButton = UISymbolButton
    lazy var logoutButton = UISymbolButton(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward")!, tintColor: .systemRed)
    
    lazy var settingsButton = UISymbolButton(image: UIImage(systemName: "gear")!, tintColor: .systemGray)

    
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
    
    deinit {
        stopTimer()
    }
     
    
    // MARK: - Private
    
    func changeBackgroundColor() {
       #if DEBUG
        contentView.backgroundColor = .systemBackground
       #else
        contentView.backgroundColor = .secondaryColor
       #endif
    }
        
    private func addSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(logoutButton)
        contentView.addSubview(settingsButton)
    }
        
    private func setupConstraints() {
        
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
        
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            statusLabel.heightAnchor.constraint(equalToConstant: 32),
            statusLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            statusLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        
            /*
            statusTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 48),
            statusTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            statusTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 32),
        
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 122),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 30),
            */
            
            logoutButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            logoutButton.heightAnchor.constraint(equalToConstant: 25),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 25),
            
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            settingsButton.heightAnchor.constraint(equalTo: logoutButton.heightAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalTo: logoutButton.widthAnchor)
            
        ])
        
        NSLayoutConstraint.activate([bottomAnchor])

    }
    
    func startTimer() {
        setStatusButton.isUserInteractionEnabled = false
        setStatusButton.setBackgroundColor(.systemGray, forState: .normal)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            if timeLeft > 0 {
                timeLeft -= 1
                setStatusButton.setTitle(localizedTimerString(seconds: timeLeft), for: .normal)
            } else {
                timer.invalidate()
                setStatusButton.setTitle(String(localized: "Set Status"), for: .normal)
                setStatusButton.isUserInteractionEnabled = true
                setStatusButton.setBackgroundColor(.accentColor, forState: .normal)
                timeLeft = 60
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
