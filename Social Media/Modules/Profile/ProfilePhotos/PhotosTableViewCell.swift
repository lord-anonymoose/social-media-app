//
//  PhotoCell.swift
//  Social Media
//
//  Created by Philipp Lazarev on 08.07.2023.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    public var userPhotos: [UIImage]? {
        didSet {
            setupPreviews(images: userPhotos ?? [UIImage]())
            setupConstraints()
        }
    }
    
    var photosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "BlackAndWhite") ?? secondaryColor
        return label
    }()

    var arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.right")?.withTintColor(UIColor(named: "BlackAndWhite") ?? .black, renderingMode: .alwaysOriginal)
        return arrow
    }()

    var imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    func getPreviewImage(images: [UIImage], index: Int) -> UIImageView? {
        let preview = UIImageView()
        preview.translatesAutoresizingMaskIntoConstraints = false
        if index < images.count {
            preview.image = images[index]
        } else {
            return nil
        }
        preview.contentMode = .scaleAspectFill
        preview.layer.cornerRadius = 6
        preview.clipsToBounds = true
        return preview
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupConstraints()
    }
    
    
    // MARK: - Private

    
    private func addSubviews() {
        contentView.addSubview(photosLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(imageStackView)
    }

    // Remove fatal error in future versions
    private func setupPreviews(images: [UIImage]) {
        for i in 0...2 {
            guard let image = getPreviewImage(images: images, index: i) else {
                preconditionFailure("Failed to PreviewImage")
            }
            imageStackView.addArrangedSubview(image)
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(greaterThanOrEqualToConstant: (contentView.frame.width - 24) / 4),
                image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.56),
            ])
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photosLabel.widthAnchor.constraint(equalToConstant: 80),
            photosLabel.heightAnchor.constraint(equalToConstant: 40),

            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImage.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 40),
            arrowImage.widthAnchor.constraint(equalToConstant: 40),

            imageStackView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}
