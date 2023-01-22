//
//  ContactViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/22.
//

import SwiftUI
import FirebaseFirestore


final class ContactViewModel: ObservableObject {
    
    @ObservedObject var authModel = GuestAuthModel()
    
    @Published var contactType: ContectType = .none
    @Published var title: String = ""
    @Published var body: String = ""
    var version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    func checkTheField() {
        
        if contactType == .none {
            // 알럿 표시 -> 유형을 선택하세요.
        }
        else if title == "" || body == "" {
            // 알럿 표시 -> 빈칸을 채워주세요.
        }
        else {
            // -> 내용 이메일로 보내기
            sendQuestion(type: contactType, title: title, body: body)
        }
    }
    
    func sendQuestion(type: ContectType, title: String, body: String) {
        
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
                "date": date
            ]
            
            
            
            Firestore.firestore().collection("Questions").addDocument(data: data) { error in
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
