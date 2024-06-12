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
    //public var userPhotosShown: [UIImage] = [UIImage]()
    //let imagePublisherFacade = ImagePublisherFacade()
    
    
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
        self.userPhotos = userPhotos
        super.init(nibName: nil, bundle: nil)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processImages(qualityOfService: .background)
        processImages(qualityOfService: .default)
        processImages(qualityOfService: .userInitiated)
        processImages(qualityOfService: .userInteractive)
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
                self.photoCollectionView.reloadData() // Reload the collection view after images are processed
            }
        }
        
        let end = DispatchTime.now() // <<<<<<<<<<<< End time
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        print("\(qualityOfService) elapsed in \(timeInterval) seconds")
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userPhotos.count
    }
        
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

//
/*
extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        // Skipping duplicate images because imagePublisherFacade.addImagesWithTimer() takes a random element from array
        self.userPhotosShown = images.unique()
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    private func setupObservers() {
        imagePublisherFacade.addImagesWithTimer(time: 5, repeat: 13, userImages: self.userPhotos)
        imagePublisherFacade.subscribe(self)
    }
}
*/
