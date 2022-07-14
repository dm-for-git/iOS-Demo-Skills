//
//  SceneDelegate.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
      guard let _ = (scene as? UIWindowScene) else { return }
//      UNUserNotificationCenter.current().delegate = self
    }
}

//extension SceneDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//
//        if let link = userInfo["photo_link"] as? String {
//          print("\n Photo Link In Foreground = \(link) \n")
//        }
//
//        completionHandler()
//    }
//}
//
