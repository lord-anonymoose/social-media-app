//
//  PhotosViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.09.2023.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Data
    
    // MARK: - Subviews
    private let photoCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
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
        title = "Photo gallery"
    }
    
    private func addSubviews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(photoCollectionView)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        
        let photo = myPhotos[indexPath.row]
        cell.setup(with: photo)
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 3
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = (accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem * 0.56)
    }
}

