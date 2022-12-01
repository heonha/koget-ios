//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI



final class LinkWidgetModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var image: UIImage?
        
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.appNameGlobal
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
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
    var appNameGlobal: String
    var url: String
    var imageName: String

    // 후가공 데이터
    var displayName: String?
    var image: UIImage?
    
    mutating func getImage(imageName: String) {
        self.image = UIImage(named: imageName)
    }
    
    mutating func getName() {
        let langStr = Locale.current.language.languageCode?.identifier
        
        if langStr == "ko" { // 한국어라면 글로벌 네임을 보여줘라.
            if appName == appNameGlobal {
                self.displayName = appName
            } else {
                self.displayName = "\(appName) (\(appNameGlobal))"
            }
        }
    }
}
