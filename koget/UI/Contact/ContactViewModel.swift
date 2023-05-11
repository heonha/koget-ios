//
//  ContactViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/22.
//

import SwiftUI
import FirebaseFirestore
import SwiftEntryKit

final class ContactViewModel: BaseViewModel {
    @ObservedObject var authModel = GuestAuthService()
    @Published var contactType: ContectType = .none
    @Published var title: String = ""
    @Published var body: String = ""

    var alertView = UIView()

    let success = S.ContactView.Alert.sendSuccess
    let successSubtitle = S.ContactView.Alert.sendSuccessSubtitle
    let requestError = S.ContactView.Alert.requestError
    let requestErrorSubtitle = S.ContactView.Alert.requestErrorTitle
    let needCheck = S.ContactView.Alert.needCheck
    let needCheckSubtitle = S.ContactView.Alert.needCheckSubtitle

    var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    func checkTheField(completion: @escaping (RequestReturnType) -> Void) {
        if contactType == .none {
            // 알럿 표시 -> 유형을 선택하세요.
            completion(.userError)
        } else if title == "" || body == "" {
            // 알럿 표시 -> 빈칸을 채워주세요.
            completion(.userError)
        } else {
            // -> 내용 이메일로 보내기
            sendQuestion(type: contactType, title: title, body: body) { result in
                switch result {
                case .error:
                    completion(.serverError)
                case .success:
                    completion(.success)
                }
            }
        }
    }

    func alertHandelr(type: RequestReturnType) {
        switch type {
        case .success:
            alertView = setAlertView()
        case .userError:
            alertView = setErrorAlertView()
        case .serverError:
            alertView = setServerErrorAlert()
        }
        presentSuccessAlert()
    }

    // Alert Presenter
    private func presentSuccessAlert() {
        SwiftEntryKit.display(entry: alertView, using: AlertFactory.whiteAlertAttribute)
    }

    // Alert Initializer
    private func setAlertView() -> UIView {
        return AlertFactory.setToastView(title: success, subtitle: successSubtitle, named: "success")
    }

    private func setServerErrorAlert() -> UIView {
        return AlertFactory.setToastView(title: requestError, subtitle: requestErrorSubtitle, named: "failed")
    }

    private func setErrorAlertView() -> UIView {
        return AlertFactory.setToastView(title: needCheck, subtitle: needCheckSubtitle, named: "failed")
    }
    
    func sendQuestion(type: ContectType, title: String, body: String, completion: @escaping(ResultType) -> Void) {
        if let guestUser = authModel.guestSession {
            let uid = guestUser.uid
            let type = type.rawValue
            let title = title
            let body = body
            let date = Date()
            
            let data: [String: Any] = [
                "uid": uid,
                "type": type,
                "title": title,
                "body": body,
                "version": version ?? "-",
                "date": date
            ]
            
            Firestore.firestore().collection("Questions").addDocument(data: data) { error in
                if let error = error {
                    completion(.error)
                } else {
                    completion(.success)
                }
            }
        } else {
            // print("로그인 되어 있지 않음.")
            return
        }
    }
}
