//
//  Coordinator.swift
//  Social Media
//
//  Created by Philipp Lazarev on 25.05.2024.
//

import UIKit

protocol Coordinator {
    //var childCoordinators: [Coordinator] { get set }

    func start() -> UIViewController
}
