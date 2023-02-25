//
//  DetailWidgetViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI
import CoreData


final class DetailWidgetViewModel: ObservableObject {
    
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
    @Published var opacityValue: Double = 1.1

    @Published var nameMaxCountError = false
    lazy var nameMaxCountErrorMessage: LocalizedStringKey = "이름의 최대글자수는 \(nameStringLimit, specifier: "%d")자 입니다."

    
    
    var targetURL: URL?
    
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.displayName
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
    }
 
    func editWidgetData(widget: DeepLink) {
        WidgetCoreData.shared.editLinkWidget(name: name, image: image, url: url, opacity: opacityValue, widget: widget)
    }
    
    func checkURLSyntex() -> Bool {
        
        if self.url.contains("://") {
            return true
        } else {
            return false
        }
        
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
    // func canOpenURL(_ urlString: String) -> Bool {
    //     guard let url = URL(string: urlString) else {return false}
    //     return UIApplication.shared.canOpenURL(url)
    // }
    // enum URLOpenError {
    //     case typeError
    //     case openError
    // }
    //
    // func checkCanOpenURL(completion: @escaping(URLOpenError?) -> Void) {
    //     if url.contains("://") {
    //         if let url = URL(string: url) {
    //             self.targetURL = url
    //             print(url)
    //             completion(nil)
    //         } else {
    //             completion(.openError)
    //         }
    //     } else {
    //         completion(.typeError)
    //     }
    // }
    //
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
