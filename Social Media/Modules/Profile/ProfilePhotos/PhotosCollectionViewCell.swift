//
//  PhotosCollectionViewCell.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.09.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private enum constants {
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalSpacing: CGFloat = 8.0
        static let topPadding: CGFloat = 8.0
    }
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        setupConstraints()
    }

    
    
    // MARK: - Private
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Public
    
    func setup(with photo: UIImage) {
        imageView.image = photo.cropSquare()
    }
}
