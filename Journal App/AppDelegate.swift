//
//  AppDelegate.swift
//  Journal App
//
//  Created by Aleyna Warner on 2025-04-11.
//

import UIKit
import AppAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    static var currentAuthorizationFlow: OIDExternalUserAgentSession?

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let flow = AppDelegate.currentAuthorizationFlow,
           flow.resumeExternalUserAgentFlow(with: url) {
            AppDelegate.currentAuthorizationFlow = nil
            return true
        }
        return false
    }
}
