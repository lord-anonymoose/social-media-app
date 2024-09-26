//
//  PostViewCell.swift
//  Social Media
//
//  Created by Philipp Lazarev on 02.07.2023.
//


import UIKit

class PostViewCell: UITableViewCell {
    
    var post: Post?
    var user: User?
    var coordinator: MainCoordinator?
        
    // MARK: - Subviews
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize:20, weight: .bold)
        return label
    }()
    
    let authorProfilePicture: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        let imageSize = CGSize(width: 30, height: 30)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize.width)
        let image = UIImage(systemName: "heart")?.withConfiguration(imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, post: Post) {
        self.post = post
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupImageTapAction()
        self.loadUserData()
        self.addSubviews()
        self.setupConstraints()
        self.loadPostData()
        self.updateLikeButton()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    // MARK: - Action
    @objc func likeButtonTapped(_ button: UIButton) {
        PostService.shared.likePost(postID: self.post?.postID) { [weak self] error in
            if let error = error {
                print("Failed to like post: \(error.localizedDescription)")
            } else {
                self?.updateLikeButton()
            }
        }
    }
    
    @objc func userTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let user = self.user {
            print(user.name)
            if let coordinator {
                if let authorID = self.post?.author {
                    coordinator.showOtherProfileViewControll(user: user, userID: authorID)
                }
            }
        } else {
            print("User not found")
        }
    }
    
    
    // MARK: - Private

    private func addSubviews() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(authorProfilePicture)
        contentView.addSubview(imgView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
    }
    
    
    private func setupImageTapAction() {
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped(_:)))
        authorProfilePicture.addGestureRecognizer(imageTapGestureRecognizer)
        let labelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped(_:)))
        authorLabel.addGestureRecognizer(labelTapGestureRecognizer)
    }
    
    private func updateLikeButton() {
        guard let postID = post?.postID else { return }

        PostService.shared.isPostLikedByCurrentUser(postID: postID) { [weak self] isLiked in
            DispatchQueue.main.async {
                let imageName = isLiked ? "heart.fill" : "heart"
                let imageSize = CGSize(width: 30, height: 30)
                let imageConfig = UIImage.SymbolConfiguration(pointSize: imageSize.width)
                self?.likeButton.setImage(UIImage(systemName: imageName)?.withConfiguration(imageConfig), for: .normal)
            }
        }
    }
    
    private func loadUserData() {
        guard let post = self.post else {
            print("Post not found")
            return
        }
        
        let path = "ProfilePictures/\(post.author).jpg"
        if let image = ImageCacheService.shared.getCachedImage(from: path) {
            self.authorProfilePicture.image = image
        } else {
            self.authorProfilePicture.image = UIImage(named: "defaultUserImage")
        }
        
        FirebaseService.shared.fetchUser(by: post.author) { user in
            self.authorLabel.text = user?.name
            self.user = user
        }
                
        ImageCacheService.shared.loadImage(from: path) { image in
            self.authorProfilePicture.image = image
        }
    }
    
    private func loadPostData() {
        guard let post = self.post else {
            print("Post not found")
            return
        }
        
        self.descriptionLabel.text = post.description
        
        let path = "Posts/\(post.postID).jpg"
        
        if let image = ImageCacheService.shared.getCachedImage(from: path) {
            self.imgView.image = image
        } else {
            self.imgView.image = UIImage(named: "defaultPostImage")
        }
        
        ImageCacheService.shared.loadImage(from: path) { image in
            self.imgView.image = image
        }
        
        do {
            let currentUserID = try FirebaseService.shared.currentUserID()
            FirebaseService.shared.fetchUser(by: currentUserID ?? "") { user in
            }
        } catch {
            print("Current user not found")
        }        
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            authorProfilePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorProfilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorProfilePicture.heightAnchor.constraint(equalToConstant: 30),
            authorProfilePicture.widthAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: authorProfilePicture.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: authorProfilePicture.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
            imgView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: likeButton.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
