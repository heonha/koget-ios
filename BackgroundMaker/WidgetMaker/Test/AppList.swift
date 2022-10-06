//
//  AppList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/05.
//

import UIKit

struct AppList {
    
    static let shared = AppList()
    
    let app: [String] = [
        "youtube",
        "instagram",
        "facebook",
        "naver"
    ]
}

struct AppInfo {
    let name: String
    let deepLink: String
}



enum AppName: String {
    case youtube = "youtube"
    case instagram = "instagram"
}
