//
//  MakePostViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.09.2024.
//

import Foundation
import UIKit



final class MakePostViewController: UIViewController {
    
    
    
    // MARK: Subviews
    private lazy var makePostButton = UICustomButton(customTitle: "Make Post".localized) { [unowned self] in
        print("Post is made")
        
        let userID = "lWoCUXvOnfWDN2VVKcK4SppBgi93"
        let postID = PostService.shared.generatePostID(for: userID)
        print("postID: \(postID)")
        let user = PostService.shared.getUserID(for: postID)
        print("userID: \(user)")
        let date = PostService.shared.getDate(for: postID)
        print("Date: \(date)")
    }
    
    
    // MARK: Actions
    
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(makePostButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            makePostButton.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            makePostButton.heightAnchor.constraint(equalToConstant: 50),
            makePostButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            makePostButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 10),
            makePostButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -10)
        ])
    }
}

