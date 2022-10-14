//
//  AppInfo.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/09.
//

import UIKit
import SwiftUI


/// DeepLinking 할 앱의 정보
struct AppInfo {
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
