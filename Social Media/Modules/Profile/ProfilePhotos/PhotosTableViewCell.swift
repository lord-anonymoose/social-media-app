//
//  PhotoCell.swift
//  Social Media
//
//  Created by Philipp Lazarev on 08.07.2023.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    // MARK: - Subviews

    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    var photosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()

    var arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
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

    func getPreviewImage(index: Int) -> UIImageView {
        let preview = UIImageView()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.image = myPhotos[index]
        preview.contentMode = .scaleAspectFill
        preview.layer.cornerRadius = 6
        preview.clipsToBounds = true
        return preview
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupPreviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupPreviews()
        setupConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(gestureAction))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - Actions

    @objc func gestureAction() {
        print("gesture action")
    }
    
    // MARK: - Private

    
    private func addSubviews() {
        contentView.addSubview(photosLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(imageStackView)
    }

    private func setupPreviews() {
        for ind in 0...2 {
            let image = getPreviewImage(index: ind)
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
