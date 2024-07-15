//
//  CustomButton.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



extension UIButton {
  func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setBackgroundImage(colorImage, for: controlState)
  }
}

final class CustomButton: UIButton {
    
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
