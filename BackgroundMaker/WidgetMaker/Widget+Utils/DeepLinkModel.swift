//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit

struct AppList {
    
    static let shared = AppList()
    
    // MARK: [Todo] CoreData로 전환이 필요한지 검토해보기
    
    let app: [AppInfo] = [
        AppInfo(id: .init(), name: "Youtube", imageName: "youtube", deepLink: "youtube", scheme: nil),
        AppInfo(id: .init(), name: "Instagram", imageName: "instagram", deepLink: "instagram",scheme: nil),
        AppInfo(id: .init(), name: "Naver", imageName: "naver", deepLink: "naversearchapp", scheme: nil),
        AppInfo(id: .init(), name: "Youtube Music", imageName: "youtubeMusic", deepLink: "youtubemusic", scheme: nil),
        AppInfo(id: .init(), name: "신한 터치결제", imageName: "shinhanTouch", deepLink: "shpayfan-touchpay", scheme: "touch"),
        AppInfo(id: .init(), name: "Google OTP", imageName: "googleOTP", deepLink: "googleauthenticator", scheme: ""),

    ]
}


