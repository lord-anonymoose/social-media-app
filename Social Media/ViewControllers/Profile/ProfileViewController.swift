//
//  ProfileViewController.swift
//  iOS_UI_HW3
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray3
        
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(profileView)
        view.addSubview(editProfileButton)
        
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileView.heightAnchor.constraint(equalToConstant: 220),
            
            editProfileButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            editProfileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            editProfileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let errorViewController = ErrorViewController()
        let navigationController = UINavigationController(rootViewController: errorViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
