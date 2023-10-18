//
//  ErrorViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 22.05.2023.
//

import UIKit

class ErrorViewController: UIViewController {

    // MARK: - Subviews

    private let imageView: UIImageView = {
        let imageName = "exclamationmark.circle"
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.tintColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Sorry, the page you were searching could not be found..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private

    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")

        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }
}
