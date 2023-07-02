//
//  PostView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 02.07.2023.
//

import UIKit

class PostViewCell: UITableViewCell {
    
    var postAuthor: String? = nil
    var postImage: String? = nil
    var postDescription: String? = nil
    var postLikes: Int? = nil
    var postViews: Int? = nil
    
    // MARK: - Subviews
    
    private lazy var author: UILabel = {
        let label = UILabel()
        
        label.text = postAuthor
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.sizeToFit()

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: postImage))
        
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var desc: UILabel = {
        let label = UILabel()
        
        label.text = postDescription
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var likes: UILabel = {
        let label = UILabel()
        
        label.text = postDescription
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var views: UILabel = {
        let label = UILabel()
        
        label.text = postDescription
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Lifecycle
    /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addSubviews()
        setupConstraints()
    }
    */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        addSubviews()
        setupConstraints()
    }

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,
         postAuthor: String, postImage: String, postDescription: String,
         postLikes: Int, postViews: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.postAuthor = postAuthor
        self.postImage = postImage
        self.postDescription = postDescription
        self.postLikes = postLikes
        self.postViews = postViews
        setupView()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupView() {
        contentView.backgroundColor = .systemBlue
        accessoryType = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(author)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            author.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            author.heightAnchor.constraint(equalToConstant: 50),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            author.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
}

