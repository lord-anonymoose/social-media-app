//
//  ProfileViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Subviews

    private lazy var profileView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()
        
        return profileView
    }()
    
    private lazy var feedView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Actions

    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        feedView.contentInset.bottom = 0.0
        feedView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        feedView.contentInset.bottom = 0.0
    }
    
    // MARK: - Private

    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(feedView)
    }

    private func setupConstraints() {
        //feedView.frame = view.bounds
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            feedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            feedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])

        feedView.delegate = self
        feedView.dataSource = self
        feedView.register(PostViewCell.self, forCellReuseIdentifier: "cell")
        feedView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
    }
    
    private func setupKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willShowKeyboard(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            notificationCenter.addObserver(
                self,
                selector: #selector(self.willHideKeyboard(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        
    private func removeKeyboardObservers() {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self)
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
        let heartImage = UIImage(systemName: "heart")?.withTintColor(UIColor.textColor)
        let attributedLikes = NSMutableAttributedString()

        let likesAttachment = NSTextAttachment()
        likesAttachment.image = heartImage
        let likesString = NSAttributedString(attachment: likesAttachment)
        attributedLikes.append(likesString)
                                                                    
        let likesCountString = NSAttributedString(string: post.likes.formattedString())
        attributedLikes.append(likesCountString)

        cell.likesLabel.attributedText = attributedLikes
        
        // Adding Views Label with SF Symbol
        let viewImage = UIImage(systemName: "eye")?.withTintColor(UIColor.textColor)
        let attributedViews = NSMutableAttributedString()

        let viewsAttachment = NSTextAttachment()
        viewsAttachment.image = viewImage
        
        let viewsString = NSAttributedString(attachment: viewsAttachment)
        attributedViews.append(viewsString)
        
        let viewsCountString = NSAttributedString(string: post.views.formattedString())
        attributedViews.append(viewsCountString)

        cell.viewsLabel.attributedText = attributedViews

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView")
            return view
        }
        return nil
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
