//
//  LocalNotificationsService.swift
//  Social Media
//
//  Created by Philipp Lazarev on 16.08.2024.
//

import Foundation
import UIKit
import UserNotifications



final class LocalNotificationsService: NSObject {
    
    static func checkNotificationSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    static func askPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
                completion(false)
                return
            }
            completion(granted)
        }
    }
    
    static func scheduleDailyNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "What's up?")
        content.body = String(localized: "See what's happening in GoSocial!")
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    static func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()
        
        let markAsReadAction = UNNotificationAction(
            identifier: "markAsRead",
            title: "Mark as Read",
            options: [.foreground]
        )
        
        let updatesCategory = UNNotificationCategory(
            identifier: "updates",
            actions: [markAsReadAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        center.setNotificationCategories([updatesCategory])
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let actionIdentifier = response.actionIdentifier
        
        if actionIdentifier == "markAsRead" {
            print("Notification marked as read")
        }
    }
}

