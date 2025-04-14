//
//  LoginView.swift
//  Journal App
//
//  Created by Aleyna Warner on 2025-04-11.
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager: AuthManager
//    @StateObject private var authManager = AuthManager()


    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Journal App")
                .font(.title)
                .padding()

            Button("Log in with Globus") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = scene.windows.first?.rootViewController {
                    authManager.authorize(from: rootVC)
                }
            }
            .padding()
            .background(ColorPalette.color3)
            .foregroundColor(ColorPalette.color5)
            .cornerRadius(10)
        }
    }
}
