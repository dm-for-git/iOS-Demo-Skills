//
//  NotificationManager.swift
//  MetaWeather
//
//  Created by DavidMartin on 7/14/22.
//

import UserNotifications
import UIKit

final class NotificationManager: NSCopying, Sendable {
    
    static let shared = NotificationManager()
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func requestUserPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, err in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            notificationCenter.getNotificationSettings(completionHandler: { settings in
                print("Permissions = \(settings)")
                guard settings.authorizationStatus == .authorized else {
                    return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        }
    }
}
