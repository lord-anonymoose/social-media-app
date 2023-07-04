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
    
    private lazy var feedView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
        return tableView
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
        feedView.frame = view.bounds
        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
        feedView.tableHeaderView = profileView
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostViewCell
        let post = myPosts[indexPath.row]
        
        cell.authorLabel.text = post.author
        cell.imgView.image = UIImage(named: post.image)
        cell.descriptionLabel.text = post.description
        
        // Adding Likes Label with SF Symbol
        let heartImage = UIImage(systemName: "heart")
        let attributedLikes = NSMutableAttributedString()

        let likesAttachment = NSTextAttachment()
        likesAttachment.image = heartImage
        let likesString = NSAttributedString(attachment: likesAttachment)
        attributedLikes.append(likesString)

        let likesCountString = NSAttributedString(string: "\(post.likes)")
        attributedLikes.append(likesCountString)

        cell.likesLabel.attributedText = attributedLikes
        
        // Adding Views Label with SF Symbol
        let viewImage = UIImage(systemName: "eye")
        let attributedViews = NSMutableAttributedString()

        let viewsAttachment = NSTextAttachment()
        viewsAttachment.image = viewImage
        let viewsString = NSAttributedString(attachment: viewsAttachment)
        attributedViews.append(viewsString)
        
        let viewsCountString = NSAttributedString(string: "\(post.views)")
        attributedViews.append(viewsCountString)

        cell.viewsLabel.attributedText = attributedViews

        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
