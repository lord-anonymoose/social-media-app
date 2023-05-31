//
//  ProfileViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileUser: User = {
        return users.randomElement() ?? User(login: "default", name: "default")
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: profileUser.login))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var profileLogin: UILabel = {
        let label = UILabel()
        label.text = "@\(profileUser.login)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.systemGray2
        return label
    }()
    
    private lazy var profileName: UILabel = {
        let label = UILabel()
        label.text = profileUser.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(profileImage)
        view.addSubview(profileLogin)
        view.addSubview(profileName)
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            
            profileLogin.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            profileLogin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            profileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            profileName.topAnchor.constraint(equalTo: profileLogin.bottomAnchor, constant: 10),
        ])
    }
}
