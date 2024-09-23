//
//  ImageCacheService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 14.09.2024.
//

import UIKit
import FirebaseStorage

class ImageCacheService {
    
    static let shared = ImageCacheService()
    
    private init() {}
    
    // NSCache for storing images
    private var imageCache = NSCache<NSString, UIImage>()
    
    // Dict for storing metadata
    private var imageMetadataCache = NSCache<NSString, StorageMetadata>()
    
    func getCachedImage(from path: String) -> UIImage? {
        let pathKey = path as NSString
        if let cachedImage = imageCache.object(forKey: pathKey) {
            return cachedImage
        } else {
            return nil
        }
    }
    
    func loadImage(from path: String, completion: @escaping (UIImage?) -> Void) {
        let pathKey = path as NSString
        
        // Check if image is cached
        if let cachedImage = imageCache.object(forKey: pathKey) {
            // Check if metadata is cached
            if let cachedMetadata = imageMetadataCache.object(forKey: pathKey) {
                let storageRef = Storage.storage().reference().child(path)
                storageRef.getMetadata { [weak self] metadata, error in
                    if let metadata = metadata, metadata.updated == cachedMetadata.updated {
                        // No need to download the image, use cached one
                        completion(cachedImage)
                    } else {
                        // Metadata differs, download new image
                        print("Metadata differs, downloading new image")
                        self?.downloadImage(from: path, completion: completion)
                    }
                }
            } else {
                // No cached metadata, fetch metadata and decide
                let storageRef = Storage.storage().reference().child(path)
                storageRef.getMetadata { [weak self] metadata, error in
                    if let metadata = metadata {
                        // Cache the metadata
                        self?.imageMetadataCache.setObject(metadata, forKey: pathKey)
                        print("No cached metadata, downloading image")
                        self?.downloadImage(from: path, completion: completion)
                    } else {
                        print("Error fetching metadata, using cached image")
                        completion(cachedImage)
                    }
                }
            }
        } else {
            // No cached image, download it
            print("No cached image, downloading image")
            downloadImage(from: path, completion: completion)
        }
    }
    
    private func downloadImage(from path: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference().child(path)
        
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка при загрузке изображения: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: path as NSString)
                
                storageRef.getMetadata { metadata, _ in
                    if let metadata = metadata {
                        self.imageMetadataCache.setObject(metadata, forKey: path as NSString)
                    }
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
    }
}
