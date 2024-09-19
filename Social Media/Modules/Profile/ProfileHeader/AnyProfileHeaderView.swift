//
//  MyProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 19.09.2024.
//

import Foundation

import UIKit

/*
class MyProfileHeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    
    //var image: UIImage?
    
    // MARK: - Subviews
    let headerView = ProfileHeaderView()


    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupConstraints()
    }
    
     
    
    // MARK: - Private
        
    private func addSubviews() {
        contentView.addSubview(headerView)
    }
        
    private func setupConstraints() {
        
        let safeAreaLayoutGuide = contentView.safeAreaLayoutGuide

        
        NSLayoutConstraint.activate([
        
        ])

    }
    
}
*/

class AnyProfileHeaderView: ProfileHeaderView {
    

    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.logoutButton.isHidden = true
        self.logoutButton.isUserInteractionEnabled = false
        self.settingsButton.isHidden = true
        self.settingsButton.isUserInteractionEnabled = false
        
        addSubviews()
        setupConstraints()
        changeBackgroundColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        setupConstraints()
    }
}

