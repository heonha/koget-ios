//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI
import Localize_Swift

enum MakeWidgetErrorType: String {
    case emptyField = "빈칸을 채워주세요."
    case emptyImage = "사진을 추가해주세요."
    case urlError = "URL에 문자열 :// 이 반드시 들어가야 합니다."
}

final class MakeWidgetViewModel: ObservableObject {
    
    let nameStringLimit: Int = 14
    let defaultImage = UIImage(named: "KogetClear")!
    
    @Published var name: String = "" {
        didSet {
            if name.count > nameStringLimit {
                name = String(name.prefix(nameStringLimit))
                nameMaxCountError = true
            } else {
                nameMaxCountError = false
            }
        }
    }
    
    @Published var url: String = ""
    @Published var image: UIImage?
    @Published var nameMaxCountError = false
    lazy var nameMaxCountErrorMessage: LocalizedStringKey = "이름의 최대글자수는 \(nameStringLimit)자 입니다."

    
    
    var targetURL: URL?
    
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.displayName
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
    }
    

    
    func addWidget() {
        WidgetCoreData.shared.addLinkWidget(name: name, image: image, url: url)
    }
    
    func editWidgetData(widget: DeepLink) {
        WidgetCoreData.shared.editLinkWidget(name: name, image: image, url: url, widget: widget)
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
    
    func checkTheTextFields(completion: @escaping(MakeWidgetErrorType?) -> Void) {
        
        if name == "" || url == "" {
            completion(.emptyField)
        }
        else if !checkURLSyntex() {
            completion(.urlError)
        }
        else if image == nil {
            completion(.emptyImage)
        }
        else {
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

enum LinkType: LocalizedStringKey {
    case app = "앱"
    case web = "웹 페이지"
}

/// DeepLinking 할 앱의 정보
struct LinkWidget {
    
    // DB 데이터
    let id = UUID()
    let type: LinkType = .app
    let name: String
    let nameKr: String
    let nameEn: String
    let url: String
    let imageName: String
    
    // 후가공 데이터
    var displayName: String
    var image: UIImage?
    var canOpen: Bool
    
}
//
// struct FBLinkModel: Codable, Identifiable {
//     @DocumentID var id: String?
//     let name: String
//     let nameKr: String
//     let nameEn: String
//     let url: String
//     let imageURL: String
//
// }
