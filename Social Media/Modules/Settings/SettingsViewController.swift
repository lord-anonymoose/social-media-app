//
//  SettingsViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import UIKit
import SwiftUI



final class SettingsViewController: UIViewController {
    
    var name: String
    var status: String
    var image: UIImage?
    
    private var hostingController: UIHostingController<SettingsView>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        setupUserImage()

        setupSettingsView()
        
    }
    
    init(name: String, status: String) {
        self.name = name
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserImage()
        
        setupSettingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserImage() {
        do {
            guard let id = try FirebaseService.shared.currentUserID() else {
                return
            }
            let path = "ProfilePictures/\(id).jpg"
            self.image = ImageCacheService.shared.getCachedImage(from: path)
        } catch {
            self.showAlert(title: "Error!".localized, description: error.localizedDescription)
        }
    }
    
    private func setupSettingsView() {
        if let hostingController = hostingController {
            hostingController.willMove(toParent: nil)
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
        }
        
        let coordinator = MainCoordinator(navigationController: self.navigationController!)
        
        let settingsView = SettingsView(coordinator: coordinator, name: name, status: status, image: image ?? UIImage(named: "defaultUserImage")!)
        
        let childView = UIHostingController(rootView: settingsView)
        hostingController = childView
        
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
