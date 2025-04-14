//
//  NotificationDelegate.swift
//  Journal App
//
//  Created by Aleyna Warner on 2025-01-15.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    // Handle notification when the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound]) // Display banner and play sound
    }

    // Handle notification interaction
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.notification.request.content.title == "Follow-Up Reminder" {
            NotificationCenter.default.post(name: Notification.Name("TriggerFollowUpQuestions"), object: nil)
        }
        completionHandler()
    }
}
