//
//  Constant.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import Foundation
import UIKit

let accentColor = UIColor(hex: "#01937C")!
let secondaryColor = UIColor(hex: "#FFC074")!
let textColor = UIColor(named: "BlackAndWhite")!
let backgroundColor = UIColor(named: "BackgroundColor")!

class CustomButton: UIButton {

    var action: (() -> Void)?

    required init(customTitle: String, customTitleColor: UIColor = .white, customBackgroundColor: UIColor = accentColor, customCornerRadius: CGFloat = 10.0) {
        
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
        action?()
    }
}
