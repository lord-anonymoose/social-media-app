//
//  Extensions.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import Foundation
import UIKit

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

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension Int {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedString = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedString
        } else {
            return "Unknown"
        }
    }
}

extension String {
    func embedSymbol(symbol: String) -> NSAttributedString {
        let image = UIImage(systemName: symbol)?.withTintColor(UIColor.textColor)
        let attributedString = NSMutableAttributedString()

        let stringAttachment = NSTextAttachment()
        stringAttachment.image = image
        let symbolString = NSAttributedString(attachment: stringAttachment)
        attributedString.append(symbolString)
                                                                    
        let textString = NSAttributedString(string: self)
        attributedString.append(textString)
        
        return attributedString
    }
}

extension UITableView {
    func hideIndicators() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}

extension UITableView {
    func feedView(isHeaderHidden: Bool = false) -> UITableView {
        var tableView = UITableView()
        if isHeaderHidden {
            //let tableView = UITableView(frame: .zero, style: .grouped)
            tableView = UITableView(frame: .zero, style: .grouped)
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.hideIndicators()
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }
}
