//
//  logInViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 28.06.2023.
//

import UIKit
import Foundation

class LogInViewController: UIViewController {
    
    private lazy var vkLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "vkLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        let backgroundImage = UIImage(named: "bluePixel")
        let backgroundImageTinted = backgroundImage?.image(alpha: 0.8)
        
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.setBackgroundImage(backgroundImageTinted, for: .selected)
        button.setBackgroundImage(backgroundImageTinted, for: .highlighted)
        button.setBackgroundImage(backgroundImageTinted, for: .disabled)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        //button.addTarget(self, action: #selector(rateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(vkLogo)
        view.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
            vkLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            vkLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            vkLogo.heightAnchor.constraint(equalToConstant: 100),
            vkLogo.widthAnchor.constraint(equalToConstant: 100),
            
            logInButton.topAnchor.constraint(equalTo: vkLogo.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
}
