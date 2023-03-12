//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI
import Localize_Swift
import SwiftEntryKit

enum MakeWidgetErrorType: String {
    case emptyField = "빈칸을 채워주세요."
    case emptyImage = "사진을 추가해주세요."
    case urlError = "URL에 문자열 :// 이 반드시 들어가야 합니다."
}

final class MakeWidgetViewModel: ObservableObject, VMOpacityProtocol, VMPhotoEditProtocol, VMTextFieldProtocol {

    @Published var alertView = UIView()

    var nameStringLimit: Int = 14
    let defaultImage = UIImage(named: "KogetClear")!
    @Published var isImageError = false
    @Published var isOpacitySliderEditing = false
    @Published var moreOptionOn = false
    @Published var isEditingMode = true
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
    lazy var nameMaxCountErrorMessage: LocalizedStringKey = "이름의 최대글자수는 \(nameStringLimit, specifier: "%d")자 입니다."

    var targetURL: URL?
    
    func getWidgetData(selectedWidget: LinkWidget) {
        self.name = selectedWidget.displayName
        self.url = selectedWidget.url
        self.image = selectedWidget.image!
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

    func makeWidgetAction(completion: @escaping(ResultType) -> Void) {
        checkTheTextFields { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                if error == .emptyImage {
                    self.isImageError.toggle()
                    completion(.error)
                } else {
                    // 실패
                    self.errorMessage = error.rawValue.localized()
                    self.alertHandelr(type: .userError)
                    completion(.error)
                }
            } else {
                // 성공
                self.addWidget()
                self.alertHandelr(type: .success)
                completion(.success)

            }
        }
    }

    // MARK: - Alerts

    func alertHandelr(type: RequestReturnType) {
        switch type {
        case .success:
            alertView = setSuccessAlert()
            displayToast()
        case .userError:
            alertView = setErrorAlertView(subtitle: errorMessage)
            displayToast()
        case .serverError:
            return
        }
    }

    private func setSuccessAlert() -> UIView {
        return EKMaker.setToastView(title: "위젯 생성 완료!", subtitle: "코젯앱을 잠금화면에 추가해 사용하세요.", named: "success")
    }

    private func setErrorAlertView(subtitle: String) -> UIView {
        return EKMaker.setToastView(title: "확인 필요", subtitle: subtitle, named: "failed")
    }

    private func displayToast() {
        SwiftEntryKit.display(entry: alertView, using: EKMaker.whiteAlertAttribute)
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
    var displayName: String = ""
    var image: UIImage?
    var canOpen: Bool = false
    
}
