//
//  AuthManager.swift
//  Journal App
//
//  Created by Aleyna Warner on 2025-04-11.
//


import Foundation
import AppAuth
import UIKit


class AuthManager: NSObject, ObservableObject {
    @Published var authState: OIDAuthState?
    
    private let issuer = URL(string: "https://auth.globus.org")!
    private let clientID = "00ef6e5a-2874-4a00-aef3-cc8d1740c2f1"
    private let redirectURI = URL(string: "https://mclabjournal.auth.globus.org/oauth2redirect")!
    private let collectionID = "cdd81df8-db63-4ea5-b017-031ba03f33ae"

    func authorize(from viewController: UIViewController) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { config, error in
            guard let config = config else {
                print("Error discovering config: \(error?.localizedDescription ?? "Unknown")")
                return
            }

            let scope = "https://auth.globus.org/scopes/\(self.collectionID)/https"

            let request = OIDAuthorizationRequest(
                configuration: config,
                clientId: self.clientID,
                clientSecret: nil,
                scopes: ["openid", scope],
                redirectURL: self.redirectURI,
                responseType: OIDResponseTypeCode,
                additionalParameters: ["access_type": "offline"]
            )

            AppDelegate.currentAuthorizationFlow = OIDAuthState.authState(
                byPresenting: request,
                presenting: viewController
            ) { authState, error in
                if let authState = authState {
                    self.authState = authState
                    print("Got access token: \(authState.lastTokenResponse?.accessToken ?? "")")
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }

    func getAccessToken(completion: @escaping (String?) -> Void) {
        authState?.performAction { accessToken, _, error in
            if let token = accessToken {
                completion(token)
            } else {
                print("Failed to get access token: \(error?.localizedDescription ?? "Unknown")")
                completion(nil)
            }
        }
    }
}
