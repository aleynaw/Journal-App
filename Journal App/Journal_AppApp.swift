//
//  Journal_AppApp.swift
//  Journal App
//
//  Created by Aleyna Warner on 2024-10-01.
//

import SwiftUI
import SwiftData
import UIKit
import AppAuth

@main
struct Journal_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthManager()
    
    init() {
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleDailyNotifications() // Schedule notifications at specific times
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared // Set the delegate
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

//    var body: some Scene {
//            WindowGroup {
//                ContentView()
//                    .environmentObject(authManager) // still injected, but auth is always "true"
//            }
//            .modelContainer(sharedModelContainer)
//        }
    
    var body: some Scene {
        WindowGroup {
            Group {
                    if authManager.authState == nil {
                      LoginView(authManager: authManager)
                    } else {
                      ContentView()
                        .environmentObject(authManager)
                    }
                  }
            .onOpenURL { url in
                    print("📬 onOpenURL: \(url)")
                    authManager.resumeAuthorizationFlow(with: url)
                  }
        }
        //.modelContainer(sharedModelContainer)
    }
}
