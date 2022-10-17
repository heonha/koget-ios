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
    let section: String?
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
    
    /// 앱에 내장된 DeepLink의 목록입니다.
    let builtInApps: [BuiltInDeepLink] = [
        BuiltInDeepLink(id: .init(), name: "Youtube", imageName: "youtube", deepLink: "youtube://", section: nil),
        BuiltInDeepLink(id: .init(), name: "Instagram", imageName: "instagram", deepLink: "instagram://",section: nil),
        BuiltInDeepLink(id: .init(), name: "Naver", imageName: "naver", deepLink: "naversearchapp://", section: nil),
        BuiltInDeepLink(id: .init(), name: "Youtube Music", imageName: "youtubeMusic", deepLink: "youtubemusic://", section: nil),
        BuiltInDeepLink(id: .init(), name: "Google OTP", imageName: "googleOTP", deepLink: "googleauthenticator://", section: nil),
        BuiltInDeepLink(id: .init(), name: "신한 터치결제", imageName: "shinhanTouch", deepLink: "shpayfan-touchpay://touch", section: nil),
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


