//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI



final class MakeWidgetViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var image: UIImage?
        
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.appName
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
    }
    
    
    func checkURLSyntex() -> Bool {
        
        if self.url.contains("://") {
            return true
        } else {
            return false
        }
           
    }
    
}

enum LinkType {
    case inApp
    case custom
}

/// DeepLinking 할 앱의 정보
struct LinkWidget {
    
    // DB 데이터
    let id = UUID()
    let type: LinkType = .inApp
    var appName: String
    var appNameEn: String
    var url: String

    // 후가공 데이터
    var displayName: String
    var image: UIImage?
    var canOpen: Bool
    
}
