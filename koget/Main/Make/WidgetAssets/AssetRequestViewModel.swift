//
//  AssetRequestViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/20.
//

import SwiftUI
import FirebaseFirestore


final class AssetRequestViewModel: ObservableObject {
    
    @ObservedObject var authModel = GuestAuthModel()
    
    @Published var contactType: ContectType = .addApp
    @Published var appName: String = ""
    @Published var body: String = ""
    var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    func checkTheField(completion: @escaping (Bool) -> Void) {
        

        if appName == "" {
            // 알럿 표시 -> 빈칸을 채워주세요.
            completion(false)
        }
        else {
            // -> 내용 이메일로 보내기
            sendQuestion(type: contactType, appName: appName, body: body)
            completion(true)

        }
    }
    
    private func sendQuestion(type: ContectType, appName: String, body: String) {
        
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
                "version": version,
                "date": date
            ]
            
            
            
            Firestore.firestore().collection("Request-Add-App").addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("전송 완료")
                }
            }
        } else {
            print("로그인 되어 있지 않음.")
            return
        }
        
       
    }
    
}
