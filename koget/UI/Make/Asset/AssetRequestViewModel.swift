//
//  AssetRequestViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/20.
//

import SwiftUI
import FirebaseFirestore
import SwiftEntryKit

final class AssetRequestViewModel: BaseViewModel {
    @ObservedObject var authModel = GuestAuthService()
    @Published var contactType: ContectType = .addApp
    @Published var appName: String = ""
    @Published var body: String = ""

    //Label name
    private let success = S.AppRequest.Alert.success
    private let successSubtitle = S.AppRequest.Alert.successSubtitle
    private let requestError = S.AppRequest.Alert.requestError
    private let requestErrorSubtitle = S.AppRequest.Alert.requestErrorSubtitle
    private let needCheck = S.AppRequest.Alert.needCheck
    private let needCheckSubtitle = S.AppRequest.Alert.needCheckSubtitle

    private let alertFactory = AlertFactory.shared

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
                if let _ = error {
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
            setAlertView()
        case .userError:
            setErrorAlertView()
        case .serverError:
            setServerErrorAlert()
        }
        alertFactory.showAlert()
    }

    private func setAlertView() {
        alertFactory.setAlertView(title: success, subtitle: successSubtitle, imageName: "success")
    }

    private func setServerErrorAlert() {
        alertFactory.setAlertView(title: requestError, subtitle: requestErrorSubtitle, imageName: "failed")
    }

    private func setErrorAlertView() {
        alertFactory.setAlertView(title: needCheck, subtitle: needCheckSubtitle, imageName: "failed")
    }
}
