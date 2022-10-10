//
//  AppInfo.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/09.
//

import Foundation

/// DeepLinking 할 앱의 정보
struct AppInfo {
    let id: UUID
    let name: String
    let imageName: String
    let deepLink: String
    let scheme: String?
}
