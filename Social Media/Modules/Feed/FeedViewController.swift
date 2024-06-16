//
//  FeedViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    // MARK: - Subviews
    
    private var loadedPosts: [StorageService.Post] = []
    
    private let viewModel: FeedVMOutput

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var feedView: UITableView = {
        let feedView = UITableView().feedView()
        self.viewModel.changeState()
        return feedView
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: FeedVMOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
        setupNavigationBar()
        bindModel()
    }
    
    @IBAction func reloadButtonTapped(sender: AnyObject) {
        self.viewModel.changeState()
    }
    
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
        view.addSubview(activityIndicator)
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: 0),
            feedView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            feedView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0)
        ])

        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Feed"

        let reloadButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise.icloud")?.withTintColor(accentColor, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(reloadButtonTapped)
        )
            
        navigationItem.rightBarButtonItems = [reloadButton]
    }
    
    private func bindModel() {
        viewModel.currentState = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                print("Feed: Initial State")
            case .loading:
                feedView.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            case .loaded(let posts):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.loadedPosts = posts
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    feedView.isHidden = false
                    feedView.reloadData()
                }
            case .error:
                print("Feed: Error")
            }
        }
    }

}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = loadedPosts[indexPath.row]
        let cell = PostViewCell(style: .default, reuseIdentifier: "cell", author: post.author, image: post.image, description: post.description, likes: post.likes, views: post.views)
        
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    
}
