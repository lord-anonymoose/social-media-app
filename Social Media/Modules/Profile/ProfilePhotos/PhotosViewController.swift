//
//  PhotosViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.09.2023.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    public var userPhotos: [UIImage] = []
    
    // MARK: - Subviews
    private let photoCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        collectionView.isUserInteractionEnabled = true
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init(userPhotos: [UIImage]) {
        self.userPhotos = myPhotos
        print("Checking in")
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
        setupObservers()
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
        self.userPhotos.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        
        let photo = self.userPhotos[indexPath.row]
        cell.setup(with: photo)
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 3
        
        let accessibleWidth = collectionView.frame.width - 36
        let widthItem = (accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 8.0
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

}

// Task 4

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        self.userPhotos += images
        print("Did receive images")
    }
    
    private func setupObservers() {
        //let imagePublisherFacade = ImagePublisherFacade()
        //print("Did set up observers")
        //imagePublisherFacade.addImagesWithTimer(time: 5, repeat: 1, userImages: myPhotos)
        //print(self.userPhotos)
    }
}
