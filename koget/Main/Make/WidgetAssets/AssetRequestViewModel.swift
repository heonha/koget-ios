//
//  AssetRequestViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/20.
//

import SwiftUI
import FirebaseFirestore
import SwiftEntryKit

enum RequestReturnType {
    case success
    case userError
    case serverError
}

enum ResultType {
    case success
    case error
}

final class AssetRequestViewModel: ObservableObject {
    @ObservedObject var authModel = GuestAuthModel()
    @Published var contactType: ContectType = .addApp
    @Published var appName: String = ""
    @Published var body: String = ""
    @Published var alertView = UIView()

    var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    func checkTheField(completion: @escaping (RequestReturnType) -> Void) {
        if appName.isEmpty {
            // 알럿 표시 -> 빈칸을 채워주세요.
            completion(.userError)
        } else {
            // -> 내용 이메일로 보내기
            sendQuestion(type: contactType, appName: appName, body: body) { result in
                switch result {
                case .error:
                    completion(.serverError)
                case .success:
                    completion(.success)
                }
            }
        }
    }
    
    private func sendQuestion(type: ContectType, appName: String, body: String, completion: @escaping(ResultType) -> Void) {
        if let guestUser = authModel.guestSession {
            let uid = guestUser.uid
            let type = type.rawValue
            let appName = appName
            let body = body
            let date = Date()
            let data: [String: Any] = [
                "uid": uid,
                "type": type,
                "appName": appName,
                "body": body,
                "version": version ?? "-",
                "date": date
            ]
            Firestore.firestore().collection("Request-Add-App").addDocument(data: data) { error in
                if let error = error {
                    completion(.error)
                } else {
                    completion(.success)
                }
            }
        } else {
            // print("로그인 되어 있지 않음.")
            completion(.error)
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

    private func setAlertView() -> UIView {
        return EKMaker.setToastView(title: "앱/웹 추가요청 성공".localized(), subtitle: "빠르게 요청에 보답하겠습니다.".localized(), named: "success")
    }

    private func setServerErrorAlert() -> UIView {
        return EKMaker.setToastView(title: "요청 전송 오류".localized(), subtitle: "요청에 실패하였습니다. 관리자에 문의하세요.".localized(), named: "failed")
    }

    private func presentSuccessAlert() {
        SwiftEntryKit.display(entry: alertView, using: EKMaker.whiteAlertAttribute)
    }

    private func setErrorAlertView() -> UIView {
        return EKMaker.setToastView(title: "확인 필요".localized(), subtitle: "앱/웹 이름을 기재해주세요.".localized(), named: "failed")
    }
}
