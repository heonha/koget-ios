//
//  DetailWidgetViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/25.
//

import SwiftUI
import SwiftEntryKit
import CoreData
import WidgetKit

enum DetailWidgetErrorType: String {
    case emptyField
    case emptyImage
    case urlError

    var localizedDescription: String {
        switch self {
        case .emptyField:
            return S.Error.emptyField
        case .emptyImage:
            return S.Error.emptyImage
        case .urlError:
            return S.Error.urlSyntax
        }
    }
}

class DetailWidgetViewModel: BaseViewModel, VMOpacityProtocol, VMPhotoEditProtocol, VMTextFieldProtocol {

    var nameStringLimit: Int = 14
    @Published var alertMessage: String = S.unknown
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

    lazy var nameMaxCountErrorMessage: String = S.Error.nameLetterLimited(nameStringLimit)

    private let alertFactory = AlertFactory.shared

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
    
    func checkTheTextFields(completion: @escaping(DetailWidgetErrorType?) -> Void) {
        
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
                    self.setAlertView(subtitle: error.localizedDescription)
                    alertFactory.showAlert()
                    return
                } else {
                    self.setAlertView()
                    self.editWidgetData(widget: widget)
                    alertFactory.showAlert()
                    self.isEditingMode = false
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        } else {
            self.isEditingMode = true
        }
    }

    // 위젯 편집 성공
    private func setAlertView() {
        return alertFactory.setToastView(title: S.Alert.editSuccessTitle, subtitle: S.Alert.editSuccessSubtitle, named: "success")
    }

    // 확인 필요
    private func setAlertView(subtitle: String) {
        return alertFactory.setToastView(title: S.Alert.needCheck, subtitle: subtitle, named: "failed")
    }
}
