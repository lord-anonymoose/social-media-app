//
//  ProfileViewController.swift
//  iOS_UI_HW3
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Subviews

    private lazy var profileView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
