//
//  DetailWidgetViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI
import Localize_Swift
import SwiftEntryKit
import CoreData

enum DetailWidgetErrorType: String {
    case emptyField = "빈칸을 채워주세요."
    case emptyImage = "사진을 추가해주세요."
    case urlError = "URL에 문자열 :// 이 반드시 들어가야 합니다."
}

class DetailWidgetViewModel: ObservableObject {
    
    let nameStringLimit: Int = 14
    @Published var alertView = UIView()

    @Published var alertMessage: String = "알수 없는 오류 발생"
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
    @Published var isOpacitySliderEditing: Bool = false
    @Published var isEditingMode = false
    @Published var nameMaxCountError = false

    lazy var nameMaxCountErrorMessage: LocalizedStringKey = "이름의 최대글자수는 \(nameStringLimit, specifier: "%d")자 입니다."

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

    func editingAction(widget: DeepLink) {

        if isEditingMode {
            checkTheTextFields { [weak self] error in
                guard let self = self else { return }

                if let error = error {
                    self.alertView = setAlertView(subtitle: error.rawValue)
                    self.displayAlert()
                    return
                } else {
                    self.alertView = setAlertView()
                    self.editWidgetData(widget: widget)
                    self.displayAlert()
                    self.isEditingMode = false
                }
            }
        } else {
            self.isEditingMode = true
        }
    }

    private func setAlertView() -> UIView {
        return EKMaker.setToastView(title: "위젯 편집 성공", subtitle: "편집된 내용은 15분 내 반영됩니다.", named: "success")
    }

    private func setAlertView(subtitle: String) -> UIView {
        return EKMaker.setToastView(title: "확인 필요", subtitle: subtitle, named: "failed")
    }

    private func displayAlert() {
        SwiftEntryKit.display(entry: alertView, using: EKMaker.whiteAlertAttribute)
    }
}
