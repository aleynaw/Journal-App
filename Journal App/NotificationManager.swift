//
//  NotificationManager.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-11-18.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton for easy access

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }

    func scheduleDailyNotifications() {
        // Example schedule: Notifications at 9:00 AM and 6:00 PM
        let times = [
            DateComponents(hour: 14, minute: 0),
            DateComponents(hour: 17, minute: 0),
            DateComponents(hour: 20, minute: 0)
        ]

        for (index, time) in times.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Daily Reminder"
            content.body = "Let's check in!"
            content.sound = UNNotificationSound.default

            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)

            let request = UNNotificationRequest(
                identifier: "daily_notification_\(index)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(time.hour ?? 0):\(time.minute ?? 0)")
                }
            }
        }
    }
    
    func scheduleFollowUpNotification(after interval: TimeInterval = 1200) {
        let content = UNMutableNotificationContent()
        content.title = "Follow-Up Reminder"
        content.body = "It’s time for a follow-up journaling session. Let’s check in!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling follow-up notification: \(error.localizedDescription)")
            } else {
                print("Follow-up notification scheduled in \(interval / 60) minutes")
            }
        }
    }

}

