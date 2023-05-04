//
//  AppStoreReviewable.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/28.
//

import Foundation
import StoreKit

protocol AppStoreReviewService {
    func requestReview()
}

extension AppStoreReviewService {
    func requestReview() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        if let windowScene = windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
}
