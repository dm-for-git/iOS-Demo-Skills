//
//  AppDelegate.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import UIKit
import CoreData
import Network
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup network's state publisher
        setupNetworkListenner()
        // You've to set this for PiP(Picture in Picture) mode.
        registerAudioCapability()
        
        // Setup notification
        NotificationManager.shared.requestUserPermission()
        return true
    }
    
    private func registerAudioCapability() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupNetworkListenner() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                NotificationCenter.default.post(name: .networkStatus, object: nil, userInfo: ["isLost": true])
            } else if path.status == .satisfied {
                NotificationCenter.default.post(name: .networkStatus, object: nil, userInfo: ["isLost": false])
            }
        }
        
        let queue = DispatchQueue(label: "Network Status Listener")
        monitor.start(queue: queue)
    }
    
    // MARK: - Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.toString()
        print("\n Device Token = \(deviceTokenString) \n")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\n \(error.localizedDescription) \n")
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MetaWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

