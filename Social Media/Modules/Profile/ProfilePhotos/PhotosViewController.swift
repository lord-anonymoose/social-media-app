//
//  PhotosViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.09.2023.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(photoCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
}
