//
//  VerificationViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 05.09.2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth


final class VerificationViewController: UIViewController {
        
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .medium)
        let image = UIImage(systemName: "envelope.fill", withConfiguration: configuration)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .accentColor
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "We have sent a verification message to your email. Please, log in to your account again using email and password.")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private lazy var confirmButton = UICustomButton(customTitle: String(localized: "Back to Log In"), action: { [self] in
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.showLogInViewController()
        }
    })
    
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = true
            navigationController.isToolbarHidden = true
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = false
            navigationController.isToolbarHidden = false
        }
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    // MARK: - Actions
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(textLabel)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Centering and positioning the imageView
            imageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50), // Set a fixed width to avoid stretching
            imageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            
            // Placing the textLabel below the imageView
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 100), // Positioning below imageView
            textLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            textLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25),
            
            // Adjusting the confirmButton placement
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 25),
            confirmButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -25)
        ])
    }
}
