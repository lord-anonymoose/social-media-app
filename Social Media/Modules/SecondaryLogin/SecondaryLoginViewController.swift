//
//  SecondaryLoginViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.08.2024.
//

import Foundation
import UIKit
import LocalAuthentication
import FirebaseAuth


class SecondaryLoginViewController: UIViewController {
    
    private var user: User
    
    
    // MARK: - Subviews
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        
        label.text = String(localized: "Hi, \(user.name) 👋")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /*
    private lazy var profilePicture: UIImageView = {
        let imageView = UIImageView(image: user.image)
        
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
                        
        imageView.isUserInteractionEnabled = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    */
    
    private lazy var changeUserButton: UIButton = {
        let button = UIButton()
        
        let imageSize = CGSize(width: 30, height: 30)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize.width)
        let image = UIImage(systemName: "arrow.left.square")?.withConfiguration(imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed

        button.addTarget(self, action: #selector(changeUserButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
        
    private lazy var authenticateButton: UIButton = {
        let button = UIButton()
        let authType = LocalAuthorizationService.biometricType()
        
        let imageSize = CGSize(width: 50, height: 50)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize.width)
        
        switch authType {
        case .face:
            let image = UIImage(systemName: "faceid")?.withConfiguration(imageConfig)
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            button.isHidden = false
        case .touch:
            let image = UIImage(systemName: "touchid")?.withConfiguration(imageConfig)
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
            button.isHidden = false
        case .optic:
            let image = UIImage(systemName: "opticid")?.withConfiguration(imageConfig)
            button.setImage(image, for: .normal)
            button.tintColor = .white // Цвет для Optic ID
            button.isHidden = false
        case .none:
            let image = UIImage(systemName: "touchid")?.withConfiguration(imageConfig)
            button.setImage(image, for: .normal)
            button.tintColor = .red
            button.isHidden = true
            button.isHidden = false
        }
        
        button.addTarget(self, action: #selector(authenticateButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        
        super.viewDidLoad()
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc func authenticateButtonTapped(_ button: UIButton) {
        print("Tapped")
        LocalAuthorizationService.authenticate(
            success: {
                if let navigationController = self.navigationController {
                    let coordinator = MainCoordinator(navigationController: navigationController)
                    coordinator.login()
                }
            },
            failure: { error in
                let title = String(localized: "Error!")
                /*self.showAlert(title: title, description: CheckerError.biometricsAuthFail.localizedDescription)
                 */
            }
        )
    }
    
    @objc func changeUserButtonTapped(_ button: UIButton) {
        do {
            try Auth.auth().signOut()
            let loginViewController = LogInViewController()
            self.navigationController?.setViewControllers([loginViewController], animated: true)
        } catch {
            let title = String(localized: "Error!")
            showAlert(title: title, description: String(localized: "Couldn't get to Log In screen."))
        }
    }
    
    // MARK: - Private
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(greetingLabel)
        //view.addSubview(profilePicture)
        view.addSubview(changeUserButton)
        view.addSubview(authenticateButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 10),
            greetingLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -10),
            greetingLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
        
        /*
            profilePicture.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            profilePicture.heightAnchor.constraint(equalToConstant: 90),
            profilePicture.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 90)
        */
        
            authenticateButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -20),
            authenticateButton.heightAnchor.constraint(equalToConstant: 100),
            authenticateButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            authenticateButton.widthAnchor.constraint(equalToConstant: 100),
        
            changeUserButton.centerYAnchor.constraint(equalTo: authenticateButton.centerYAnchor),
            changeUserButton.heightAnchor.constraint(equalToConstant: 50),
            changeUserButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            changeUserButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
