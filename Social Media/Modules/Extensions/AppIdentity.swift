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

final class CustomButton: UIButton {
    
    typealias Action = () -> Void
    
    var buttonAction: Action

    required init(customTitle: String, customTitleColor: UIColor = .white, customBackgroundColor: UIColor = accentColor, customCornerRadius: CGFloat = 10.0, action: @escaping Action) {
        
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

class UITextFieldWithPadding: UITextField {
    
    // MARK: - Subviews
    
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 0
    )
    
    // MARK: - Lifecycle
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
