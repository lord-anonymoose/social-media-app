//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    private lazy var postButtons: [UIButton] = {
        var postButtons = [UIButton]()
        var count = 0
        
        for post in posts {
            var post = UIButton(type: .system)
            post.setTitleColor(.label, for: .normal)
            post.sizeToFit()
            post.titleLabel?.numberOfLines = 0
            post.titleLabel?.lineBreakMode = .byWordWrapping

            post.layer.borderColor = UIColor.black.cgColor
            post.layer.borderWidth = 1
            post.layer.cornerRadius = 20
            
            post.tag = count
            count += 1
            
            let title = "\(posts[post.tag].user.name)'s post"
            post.setTitle(title, for: .normal)
            
            post.addTarget(self, action: #selector(tapFunction), for: .touchUpInside)

            postButtons.append(post)
        }
        return postButtons
    }()

    private lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
            
        for button in postButtons {
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newSetupUI()
    }
    
    func newSetupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20.0
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20.0
            ),
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16.0
            ),
            stackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16.0
            ),
        ])
    }
         
    @objc func tapFunction(sender: UIButton) {
        let postViewController = PostViewController(post: posts[sender.tag])
        postViewController.title = "@\(posts[sender.tag].user.login)"
        let errorViewController = ErrorViewController()
        let navigationController = UINavigationController(rootViewController: errorViewController)
        navigationController.pushViewController(postViewController, animated: true)
        present(navigationController, animated: true)
    }
}
