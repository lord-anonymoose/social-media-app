//
//  PostView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 05.07.2023.
//

import UIKit

class PostView: UIView {
    
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
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    // MARK: - Lifecycle

    init(frame: CGRect, author: String, image: String, description: String, likes: Int) {
        super.init(frame: frame)
        setupConstraints()
        addSubviews(author: author, image: image, description: description, likes: likes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    // MARK: - Private

    private func addSubviews(author: String, image: String, description: String, likes: Int) {
        addSubview(authorLabel)
        addSubview(authorProfilePicture)
        addSubview(imgView)
        addSubview(descriptionLabel)
        addSubview(likesLabel)
        
        authorLabel.text = author
        authorProfilePicture.image = UIImage(named: author)
        imgView.image = UIImage(named: image)
        descriptionLabel.text = description
        likesLabel.attributedText = likes.formattedString().embedSymbol(symbol: "heart")
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            authorProfilePicture.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            authorProfilePicture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authorProfilePicture.heightAnchor.constraint(equalToConstant: 30),
            authorProfilePicture.widthAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: authorProfilePicture.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: authorProfilePicture.trailingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
            // Как самому захотелось
            // imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: (imgView.image?.size.height ?? 1) / (imgView.image?.size.width ?? 1)),
            imgView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: likesLabel.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            likesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            likesLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}
