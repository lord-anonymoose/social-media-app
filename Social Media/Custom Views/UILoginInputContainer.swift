//
//  LoginInputContainer.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



final class UILoginInputContainer: UIView {
    
    required init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
