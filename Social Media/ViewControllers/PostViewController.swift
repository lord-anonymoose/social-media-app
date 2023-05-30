//
//  PostViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    private var post: Post
    
    private lazy var postUserImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: post.user.login))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var postUserName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = post.user.name
        label.font = UIFont.systemFont(ofSize:20, weight: .bold)
        return label
    }()
    
    private lazy var postText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = post.text
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(postUserImage)
        view.addSubview(postUserName)
        view.addSubview(postText)
        
        NSLayoutConstraint.activate([
            postUserImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            postUserImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            postUserImage.heightAnchor.constraint(equalToConstant: 90),
            postUserImage.widthAnchor.constraint(equalToConstant: 90),
            
            postUserName.leadingAnchor.constraint(equalTo: postUserImage.trailingAnchor, constant: 20),
            postUserName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            postText.leadingAnchor.constraint(equalTo: postUserImage.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            postText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            postText.topAnchor.constraint(equalTo: postUserName.bottomAnchor, constant: 20),
        ])
        
        postText.numberOfLines = 0
        postText.lineBreakMode = .byWordWrapping
        postText.sizeToFit()
        
        let infoButton = UIButton(type: .system)
        infoButton.setTitle("Info", for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonPressed(_:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func infoButtonPressed(_ sender: UIButton) {
        let infoViewController = InfoViewController()
        infoViewController.title = "Information"
        
        let navigationController = UINavigationController(rootViewController: infoViewController)
        
        present(navigationController, animated: true)
    }
}
