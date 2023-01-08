//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI

enum MakeErrorType: String {
    case emptyField = "빈칸을 채워주세요."
    case emptyImage = "사진을 추가해주세요."
    case urlError = "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)"
}

final class MakeWidgetViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var image: UIImage?
    
    var targetURL: URL?
    
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
    
    func canOpenURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {return false}
        return UIApplication.shared.canOpenURL(url)
    }
    
    func checkTheTextFields(completion: @escaping(MakeErrorType?) -> Void) {
        
        if name == "" || url == "" {
            completion(.emptyField)
        }
        else if image == nil {
            completion(.emptyImage)
        }
        else if !checkURLSyntex() {
            completion(.urlError)
        }
        else {
            let item = DeepLink(context: WidgetCoreData.shared.coredataContext)
            item.id = UUID()
            item.name = name
            item.image = image?.pngData()
            item.url = url
            item.addedDate = Date()
            
            WidgetCoreData.shared.addDeepLinkWidget(widget: item)

            completion(nil)
        }
    }
    
    enum URLOpenError {
        case typeError
        case openError
    }
    
    func checkCanOpenURL(completion: @escaping(URLOpenError?) -> Void) {
        if url.contains("://") {
            if let url = URL(string: url) {
                self.targetURL = url
                print(url)
                completion(nil)
            } else {
                completion(.openError)
            }
        } else {
            completion(.typeError)
        }
    }
    
    func openURL(completion: @escaping(Bool) -> Void) {
        if let url = self.targetURL {
            UIApplication.shared.open(url) { bool in
                completion(bool)
            }
        } else {
            completion(false)
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
