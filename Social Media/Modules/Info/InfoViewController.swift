//
//  InfoViewController.swift
//  iOS UI HW2
//
//  Created by Philipp Lazarev on 18.05.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var rateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle(String(localized: "  Rate the App  "), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(rateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc func rateButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: String(localized: "Rate my App"), message: String(localized: "Let me know how you like my app!"), preferredStyle: .alert)
        let goodAction = UIAlertAction(title: "👍", style: .default) {
            UIAlertAction in
            //NSLog(String(localized: "Thank you! I appreciate it!"))
        }
        let badAction = UIAlertAction(title: "👎", style: .default) {
            UIAlertAction in
            //NSLog("Let me know how I can improve it!")
        }
        alertController.addAction(goodAction)
        alertController.addAction(badAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private

    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(rateButton)
        NSLayoutConstraint.activate([
            rateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
