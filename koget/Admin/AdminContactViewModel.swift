//
//  AdminContactViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/05.
//

import Foundation
import FirebaseFirestore


class AdminContactViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    func fetchQuestion() {
        
        db.collection("Questions").getDocuments { document, error in
            if let error = error {
                print(error)
                return
            }
            
            if let document = document {
                let documents = document.count
                print(documents)
            }
            
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
            
            
        }
        
        
        
    }
    
    // 문의 가져오기
    // 문의 데이터 -> Contact 데이터로 변환
    // 리턴하기.
    
    
    
}
