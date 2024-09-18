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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = . green

        let childView = UIHostingController(rootView: SettingsView(name: self.name, status: self.status))
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    
    init(name: String, status: String) {
        self.name = name
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
