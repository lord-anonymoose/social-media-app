//
//  ProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//

// Adding comment just to check

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var timeLeft: Int = 60
    var timer: Timer?
    
    // MARK: - Subviews
    
    public var user: StorageService.User? {
        didSet {
            userImage.image = UIImage(named: user?.login ?? "default")
            userName.text = user?.login ?? "default"
            userStatus.text = user?.status ?? "Type in something..."
            setupConstraints()
        }
    }
    
    private var statusText: String = ""
    
    lazy var userImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "default"))
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
                        
        imageView.isUserInteractionEnabled = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        
        userName.text = "default"
        userName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userName.textColor = textColor
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
    
    private lazy var setStatusButton = CustomButton(customTitle: "Set Status") {[unowned self] in
        userStatus.text = self.statusText
        if self.user != nil {
            /*
            for i in 0...users.count - 1 {
                if users[i].login == self.user?.login {
                    users[i].status = self.statusText
                }
            }
            */
        }
        startTimer()
    }
    
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
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self

        return textField
    }()

    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSuviews()
        //setupConstraints()
        changeBackgroundColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSuviews()
        setupConstraints()
        changeBackgroundColor()
    }
    
    deinit {
        stopTimer()
    }
     
    
    
    // MARK: - Actions
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text
        }
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
        contentView.addSubview(setStatusButton)
    }
        
    private func setupConstraints() {
        
        let safeAreaLayoutGuide = contentView.safeAreaLayoutGuide

        let bottomAnchor = setStatusButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.0)
        bottomAnchor.priority = .required - 1
             
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userImage.widthAnchor.constraint(equalToConstant: 90),
            userImage.heightAnchor.constraint(equalToConstant: 90),
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            userStatus.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userStatus.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 48),
            textField.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        NSLayoutConstraint.activate([
            setStatusButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([bottomAnchor])

    }
    
    func startTimer() {
        setStatusButton.isUserInteractionEnabled = false
        setStatusButton.setBackgroundColor(.systemGray, forState: .normal)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            if timeLeft > 0 {
                timeLeft -= 1
                setStatusButton.setTitle("\(timeLeft) seconds left", for: .normal)
            } else {
                timer.invalidate()
                setStatusButton.setTitle("Set Status", for: .normal)
                setStatusButton.isUserInteractionEnabled = true
                setStatusButton.setBackgroundColor(accentColor, forState: .normal)
                timeLeft = 60
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
