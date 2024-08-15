//
//  Extensions.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import Foundation
import UIKit



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



extension Array where Element: UIImage {
    func unique() -> [UIImage] {
        var unique = [UIImage]()
        for image in self {
            if !unique.contains(image) {
                unique.append(image)
            }
        }
        return unique
    }
}



extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
