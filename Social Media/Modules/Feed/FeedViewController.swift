//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Subviews

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var feedView: UITableView = {
        let feedView = UITableView().feedView()
        return feedView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        let service = FeedService()
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: 0),
            feedView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            feedView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0)
        ])

        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = PostViewCell(style: .default, reuseIdentifier: "cell", author: post.author, image: post.image, description: post.description, likes: post.likes, views: post.views)
        
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    
}
