//
//  MyProfileHeaderView.swift
//  Social Media
//
//  Created by Philipp Lazarev on 19.09.2024.
//

import Foundation
import UIKit



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

