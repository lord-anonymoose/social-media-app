//
//  UIImage.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func cropSquare() -> UIImage {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        let cropSize = min(originalWidth, originalHeight)
        
        let cropRect = CGRect(x: (originalWidth - cropSize) / 2, y: (originalHeight - cropSize) / 2, width: cropSize, height: cropSize)
        
        if let cgImage = self.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return self
    }
}
