//
//  PhotosViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 06.09.2023.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    public var isMyUser: Bool
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
    init(userPhotos: [UIImage], isMyUser: Bool) {
        self.userPhotos = userPhotos
        self.isMyUser = isMyUser
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
        
        guard !self.userPhotos.isEmpty else {
            print("No images to process")
            return
        }
        
        processImages(qualityOfService: .background)
        processImages(qualityOfService: .default)
        processImages(qualityOfService: .userInitiated)
        processImages(qualityOfService: .userInteractive)
    }
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = String(localized: "Photo gallery")
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
    
    private func processImages(qualityOfService: QualityOfService) { // Applying filter to images
        let imageProcessor = ImageProcessor()
        var processedPhotos = [UIImage]()
        
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        
        imageProcessor.processImagesOnThread(
            sourceImages: self.userPhotos,
            filter: .chrome,
            qos: qualityOfService
        ) { processedImages in
            // Handle the processed images
            for processedImage in processedImages {
                if let cgImage = processedImage {
                    let image = UIImage(cgImage: cgImage)
                    processedPhotos.append(image)
                }
            }
            DispatchQueue.main.async {
                self.userPhotos = processedPhotos
                self.photoCollectionView.reloadData()
                
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("\(qualityOfService) elapsed in \(timeInterval) seconds")
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userPhotos.count
    }
        
    // Throwing error
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        
        let photo = userPhotos[indexPath.row]
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
