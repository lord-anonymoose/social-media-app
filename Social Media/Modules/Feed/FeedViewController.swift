//
//  FeedViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 20.09.2024.
//

import Foundation
import UIKit



final class FeedViewController: UIViewController, UITableViewDelegate {
    
    var posts = [Post]()
    var userImages = [UIImage?]()
    var postImages = [UIImage]()
    
    
    
    // MARK: Subviews
    let refreshControl = UIRefreshControl()
    
    private lazy var feedView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: Actions
    @objc func addPostTapped() {
        print("addTapped")
    }
    
    @objc func showBookmarksTapped() {
        print("showBookmarksTapped")
    }
    
    @objc private func refresh() {
        self.loadPosts()
        self.feedView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        setupUI()
        setupNavigationBar()
        addSubviews()
        setupConstraints()
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        self.navigationController?.title = "GoSocial"
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "GoSocial"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostTapped))
        
        let bookmarkImage = UIImage(systemName: "bookmark.fill")
        let bookmarksButton = UIBarButtonItem(image: bookmarkImage, style: .plain, target: self, action: #selector(showBookmarksTapped)
        )
        navigationItem.rightBarButtonItem = bookmarksButton
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing".localized)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        feedView.addSubview(refreshControl)
    }
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            feedView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            feedView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            feedView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
        
        feedView.delegate = self
        feedView.dataSource = self
        
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
        feedView.register(ProfileHeaderView
            .self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        feedView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
    }
    
    private func loadPosts() {
        PostService.shared.fetchAllPosts { [weak self] fetchedPosts in
            guard let self = self else { return }
            
            self.posts = fetchedPosts
            
            DispatchQueue.main.async {
                self.feedView.reloadData()
            }
            print(posts.count)
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = PostViewCell(style: .default, reuseIdentifier: "cell", post: post)
        if let navigationController = self.navigationController {
            let coordinator = MainCoordinator(navigationController: navigationController)
            cell.coordinator = coordinator
        } else {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
