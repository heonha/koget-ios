//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI
import SwiftEntryKit
import WidgetKit

enum MakeWidgetErrorType {
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

final class MakeWidgetViewModel: BaseViewModel, VMOpacityProtocol, VMPhotoEditProtocol, VMTextFieldProtocol {

    private let alertFactory = AlertFactory.shared

    var nameStringLimit: Int = 14
    let defaultImage = CommonImages.emptyIcon

    @Published var isImageError = false
    @Published var isOpacitySliderEditing = false
    @Published var isEditingMode = true

    @Published var moreOptionOn = false
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
    @Published var errorMessage = ""
    @Published var nameMaxCountError = false

    lazy var nameMaxCountErrorMessage = S.Error.nameLetterLimited(nameStringLimit)

    var targetURL: URL?
    
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.displayName
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
    }

    // Web & App 구분
    func checkLinkType(url: String) -> LinkType {
        if url.lowercased().contains("http://") || url.lowercased().contains("https://") {
            return LinkType.web
        } else {
            return LinkType.app
        }
    }

    func addWidget() {
        WidgetCoreData.shared.addLinkWidget(name: name, image: image, url: url, opacity: opacityValue)
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
                // print(url)
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

    func makeWidgetAction(completion: @escaping(MakeWidgetErrorType?) -> Void) {
        checkTheTextFields { [weak self] error in
            guard let self = self else { return }

            if let error = error {

                switch error {
                case .emptyField:
                    self.errorMessage = error.localizedDescription
                    self.alertHandelr(type: .userError)
                    completion(error)
                case .emptyImage:
                    self.isImageError.toggle()
                    completion(error)
                case .urlError:
                    completion(error)
                }
            } else {
                // 성공
                self.addWidget()
                self.alertHandelr(type: .success)
                
                completion(nil)
                WidgetCenter.shared.reloadAllTimelines()

            }
        }
    }

    // MARK: - Alerts

    func alertHandelr(type: RequestReturnType) {
        switch type {
        case .success:
            setSuccessAlert()
            alertFactory.showAlert()
        case .userError:
            setErrorAlertView(subtitle: errorMessage)
            alertFactory.showAlert()
        case .serverError:
            return
        }
    }

    private func setSuccessAlert() {
        alertFactory.setAlertView(title: S.Alert.Success.title, subtitle: S.Alert.Success.subtitle, imageName: "success")
    }

    private func setErrorAlertView(subtitle: String) {
        alertFactory.setAlertView(title: S.Alert.needCheck, subtitle: subtitle, imageName: "failed")
    }

}

enum LinkType {
    case app
    case web

    var localizedString: String {
        switch self {
        case .app:
            return S.WidgetCell.WidgetType.app
        case .web:
            return S.WidgetCell.WidgetType.web
        }
    }

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
    var displayName: String = ""
    var image: UIImage?
    var canOpen: Bool = false
    
}
