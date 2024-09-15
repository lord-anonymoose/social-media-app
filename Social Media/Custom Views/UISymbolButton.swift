//
//  UISymbolButton.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import UIKit

final class UISymbolButton: UIButton {
    required init(image: UIImage, tintColor: UIColor) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        self.tintColor = tintColor
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*
 final class UICustomButton: UIButton {
     
     typealias Action = () -> Void
     
     var buttonAction: Action

     required init(customTitle: String, customTitleColor: UIColor = .white, customBackgroundColor: UIColor = .accentColor, customCornerRadius: CGFloat = 10.0, action: @escaping Action) {
         
         buttonAction = action
         
         super.init(frame: .zero)
         
         translatesAutoresizingMaskIntoConstraints = false
         
         setTitle(customTitle, for: .normal)
         
         setTitleColor(customTitleColor, for: .normal)
         setTitleColor(customTitleColor.withAlphaComponent(0.3), for: .highlighted)
         
         setBackgroundColor(customBackgroundColor, forState: .normal)
         setBackgroundColor(customBackgroundColor.withAlphaComponent(0.3), forState: .highlighted)
         
         layer.cornerRadius = customCornerRadius
         layer.masksToBounds = true
         
         addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     @objc private func buttonTapped() {
         buttonAction()
     }
 }

 
 */
