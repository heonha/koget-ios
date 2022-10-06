//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit

struct AppList {
    
    static let shared = AppList()
    
    let app: [AppInfo] = [
        AppInfo(name: "youtube", deepLink: "youtube", scheme: nil),
        AppInfo(name: "instagram", deepLink: "instagram",scheme: nil),
        AppInfo(name: "naver", deepLink: "naversearchapp", scheme: nil),
        AppInfo(name: "신한 터치결제", deepLink: "shpayfan-touchpay", scheme: "touch"),
    ]
}

struct AppInfo {
    let name: String
    let deepLink: String
    let scheme: String?
}

enum AppName: String {
    case youtube = "youtube"
    case instagram = "instagram"
}
