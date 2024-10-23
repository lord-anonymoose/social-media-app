//
//  TimerLocalization.swift
//  Social Media
//
//  Created by Philipp Lazarev on 15.08.2024.
//

import Foundation



public func localizedTimerString(seconds: Int) -> String {
    let number = seconds % 10
    
    switch number {
    case 1:
        return String(localized: "\(seconds) секунда")
    case 2...4:
        return String(localized: "\(seconds) секунды")
    case 0, 5...9:
        return String(localized: "\(seconds) секунд")
    default:
        return String(localized: "\(seconds) seconds")
    }
    
}
