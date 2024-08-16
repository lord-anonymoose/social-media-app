//
//  LocalNotificationsService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 16.08.2024.
//

import Foundation
import UserNotifications



class LocalNotificationsService {
        
    static func checkPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                askPermission()
                scheduleDailyNotification()
            case .denied:
                print("Notification access denied")
            case .authorized:
                print("Notification access authorized")
            case .provisional:
                scheduleDailyNotification()
            case .ephemeral:
                print("Ephemeral notifications are not supported")
            @unknown default:
                print("New notification type is not supported")
            }
        }
    }
        
    static func askPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
    
    static func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "What's up?")
        content.body = String(localized: "See what's happening in GoSocial!")
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

extension Notification.Name {
    static let didRegisterNotification = Notification.Name("didRegisternNotification")
}
