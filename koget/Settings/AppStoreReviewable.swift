//
//  AppStoreReviewable.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/28.
//

import Foundation
import StoreKit

protocol AppStoreReviewable {
    func requestReview()
}


extension AppStoreReviewable {
    
    func requestReview() {
        
        // [현재 연결된 뷰 화면 얻어오기 : IOS 15 대응]
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
