//
//  PostViewCell.swift
//  Social Media
//
//  Created by Philipp Lazarev on 02.07.2023.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize:20, weight: .bold)
        return label
    }()
    
    let authorProfilePicture: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView()
        
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
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
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.addTarget(PostViewCell.self, action: #selector(likeButtonTapped), for: .touchUpInside)
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

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, author: String, image: String, description: String, likes: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: author, image: image, description: description)
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(author: "Unknown", image: "notFound", description: "Unknown")
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews(author: "Unknown", image: "notFound", description: "Unknown")
        setupConstraints()
    }
    
    // MARK: - Action
    @objc func likeButtonTapped(_ button: UIButton) {
        print("likeButtonTapped")
    }
    
    
    // MARK: - Private

    private func addSubviews(author: String, image: String, description: String) {
        contentView.addSubview(authorLabel)
        contentView.addSubview(authorProfilePicture)
        contentView.addSubview(imgView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeButton)
        
        authorLabel.text = author
        authorProfilePicture.image = UIImage(named: author)
        
        imgView.image = UIImage(named: image)
        
        descriptionLabel.text = description
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
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likeButton.widthAnchor.constraint(equalToConstant: 25),
            likeButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
