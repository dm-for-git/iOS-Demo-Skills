//
//  NotificationService.swift
//  MetaNotificationService
//
//  Created by DavidMartin on 7/14/22.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        print("didReceive get called")
        if let bestAttemptContent = bestAttemptContent,
            let photoLink = bestAttemptContent.userInfo["photo_link"] as? String {
            print("photo_link is existed")
            PhotoDownloader.shared.downloadPhotoFrom(photoUrl: photoLink) {[weak self] photo in
                print("download photo successfully")
                
                let identifier = "photoAttachment.png"
                
                if let fileUrl = self?.saveImageAttachment(image: photo, forIdentifier: identifier),
                   let photoAttachment = try? UNNotificationAttachment(identifier: identifier, url: fileUrl) {
                    print("Photo Extension Is Created!!!")
                    bestAttemptContent.attachments = [photoAttachment]
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            print("Notification Service Time Expired!!!")
            contentHandler(bestAttemptContent)
        }
    }
    
    // MARK: Utilities
    private func saveImageAttachment(image: UIImage, forIdentifier identifier: String) -> URL? {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let directoryPath = tempDirectory.appendingPathComponent(
            ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true,
                                                    attributes: nil)
            let fileURL = directoryPath.appendingPathComponent(identifier)
            guard let imageData = image.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            print("\n \(error.localizedDescription) \n")
            return nil
        }
    }

}
