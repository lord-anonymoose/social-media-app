//
//  SettingsViewController.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.09.2024.
//

import UIKit
import SwiftUI

final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = . green

        let childView = UIHostingController(rootView: SettingsView())
        addChild(childView)
        childView.view.frame = view.bounds
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
