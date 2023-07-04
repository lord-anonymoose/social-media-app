//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: - Subviews

    private lazy var post: UIButton = {
        var post = UIButton(type: .system)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.setTitleColor(.label, for: .normal)
        post.sizeToFit()
        post.titleLabel?.numberOfLines = 0
        post.titleLabel?.lineBreakMode = .byWordWrapping
        post.backgroundColor = .systemOrange
        post.layer.borderColor = UIColor.black.cgColor
        post.layer.borderWidth = 1
        post.layer.cornerRadius = 10
        
        // Setting post title
        post.tag = 0
        let title = "\(posts[post.tag].user.name)'s post"
        post.setTitle(title, for: .normal)
        
        // Adding target function
        post.addTarget(self, action: #selector(tapFunction), for: .touchUpInside)
        return post
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
         
    @objc func tapFunction(sender: UIButton) {
        let postViewController = PostViewController(post: posts[sender.tag])
        postViewController.title = "@\(posts[sender.tag].user.login)"
        let errorViewController = ErrorViewController()
        let navigationController = UINavigationController(rootViewController: errorViewController)
        navigationController.pushViewController(postViewController, animated: true)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(post)
        NSLayoutConstraint.activate([
            post.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            post.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            post.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
}
