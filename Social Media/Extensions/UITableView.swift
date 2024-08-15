//
//  UITableView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.07.2024.
//

import UIKit



extension UITableView {
    func hideIndicators() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}

extension UITableView {
    func feedView(isHeaderHidden: Bool = false) -> UITableView {
        var tableView = UITableView()
        if isHeaderHidden {
            tableView = UITableView(frame: .zero, style: .grouped)
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.hideIndicators()
        tableView.sectionHeaderTopPadding = 0
        
        return tableView
    }
}
