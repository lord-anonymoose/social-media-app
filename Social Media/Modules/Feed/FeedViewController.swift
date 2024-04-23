//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Subviews

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
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            feedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            feedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
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
