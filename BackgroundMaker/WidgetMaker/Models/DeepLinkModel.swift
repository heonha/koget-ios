//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit
import CoreData
import SwiftUI

/// DeepLinking 할 앱의 정보
struct BuiltInDeepLink {
    let id: UUID
    let name: String
    let imageName: String
    let deepLink: String
    let scheme: String?
}


struct CustomWidgetInfo {
    let id: UUID
    let name: String
    let image: Image?
    let text: String?
}

class WidgetModel {
    
    static let shared = WidgetModel()
    
    // MARK: [Todo] CoreData로 전환이 필요한지 검토해보기
    
    let app: [BuiltInDeepLink] = [
        BuiltInDeepLink(id: .init(), name: "Youtube", imageName: "youtube", deepLink: "youtube://", scheme: nil),
        BuiltInDeepLink(id: .init(), name: "Instagram", imageName: "instagram", deepLink: "instagram://",scheme: nil),
        BuiltInDeepLink(id: .init(), name: "Naver", imageName: "naver", deepLink: "naversearchapp://", scheme: nil),
        BuiltInDeepLink(id: .init(), name: "Youtube Music", imageName: "youtubeMusic", deepLink: "youtubemusic://", scheme: nil),
        BuiltInDeepLink(id: .init(), name: "Google OTP", imageName: "googleOTP", deepLink: "googleauthenticator://", scheme: ""),
        BuiltInDeepLink(id: .init(), name: "신한 터치결제", imageName: "shinhanTouch", deepLink: "shpayfan-touchpay://touch", scheme: "touch"),
    ]
    
    
    var deepLinkApps: [DeepLink] = []

    
    func searchImage(id: String) -> UIImage {
        
        
        // 딥링크 앱의 배열을 가져온다.
        let deepLinkApps = CoreData.shared.getStoredDataForDeepLink()!
        
        for apps in deepLinkApps {
            if id == apps.id!.uuidString {
                
                let image = UIImage(data: apps.image!)
                
                return image!
                
            }
        }

        return UIImage(named: "Image")!
    }
    
    func testImage(id: String) -> UIImage? {
        
        return UIImage(named: id)
    }
    
    func debugIntent(data: String) {
        print("DebugIntent: \(data)")
    }
    
}


