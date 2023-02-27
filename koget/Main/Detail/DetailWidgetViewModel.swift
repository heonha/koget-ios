//
//  DetailWidgetViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI
import Localize_Swift

enum DetailWidgetErrorType: String {
    case emptyField = "빈칸을 채워주세요."
    case emptyImage = "사진을 추가해주세요."
    case urlError = "URL에 문자열 :// 이 반드시 들어가야 합니다."
}

final class DetailWidgetViewModel: ObservableObject {
    
    let nameStringLimit: Int = 14
    
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
    @Published var opacityValue: Double = 1.0
    @Published var isEditing: Bool = false


    @Published var nameMaxCountError = false
    lazy var nameMaxCountErrorMessage: LocalizedStringKey = "이름의 최대글자수는 \(nameStringLimit, specifier: "%d")자 입니다."

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
    
    
}

