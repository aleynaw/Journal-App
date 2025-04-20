import UIKit
import AppAuthCore

class AppDelegate: UIResponder, UIApplicationDelegate {
  var currentAuthorizationFlow: OIDExternalUserAgentSession?

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if let flow = currentAuthorizationFlow,
       flow.resumeExternalUserAgentFlow(with: url) {
      currentAuthorizationFlow = nil
      return true
    }
    return false
  }
}
