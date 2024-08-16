//
//  LoadingViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 16.08.2024.
//

import Foundation
import UIKit



class LoadingViewController: UIViewController {
    
    
    
    // MARK: - Subviews
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.isHidden = false
        indicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
    
    
    // MARK: - Private
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 200),
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
