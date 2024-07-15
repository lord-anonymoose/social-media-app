//
//  UIColor.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



extension UIColor {
    static var accentColor: UIColor {
        return UIColor(hex: "#01937C") ?? .systemBlue
    }
    
    static var secondaryColor: UIColor {
        return UIColor(hex: "#FFC074") ?? .systemBlue
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexCleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexCleaned = hexCleaned.replacingOccurrences(of: "#", with: "")
        
        let length = hexCleaned.count
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        guard Scanner(string: hexCleaned).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    static var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                // Return one of two colors depending on light or dark mode
                return (traits.userInterfaceStyle == .dark ?
                    UIColor(hex: "#FFC074") : UIColor(hex: "#01937C")) ?? .white
            }
        } else {
            // Same old color used for iOS 12 and earlier
            return UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)
        }
    }
}
