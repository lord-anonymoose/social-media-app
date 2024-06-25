//
//  PlanetViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.06.2024.
//

import Foundation

import UIKit

class PlanetViewController: UIViewController {
    
    // MARK: - Subviews
    
    /*
    private lazy var rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("  Rate the App  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(rateButtonPressed), for: .touchUpInside)
        return button
    }()
    */
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    /*
    @objc func rateButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Rate my App", message: "Let me know how you like my app!", preferredStyle: .alert)
        let goodAction = UIAlertAction(title: "👍", style: .default) {
            UIAlertAction in
            NSLog("Thank you! I appreciate it!")
        }
        let badAction = UIAlertAction(title: "👎", style: .default) {
            UIAlertAction in
            NSLog("Let me know how I can improve it!")
        }
        alertController.addAction(goodAction)
        alertController.addAction(badAction)
        present(alertController, animated: true, completion: nil)
    }
    */
    
    // MARK: - Private

    func setupUI() {
        //view.backgroundColor = UIColor(named: "BackgroundColor")
        view.backgroundColor = .systemOrange
    }
}
