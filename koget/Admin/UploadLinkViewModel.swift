//
//  UploadLinkViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/10.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct FBLinkModel: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let nameKr: String
    let nameEn: String
    let url: String
    let imageURL: String
    
}

final class UploadLinkViewModel: ObservableObject {
    
    
    
    
    func addLinkWidgetAppToFirebase(name: String, nameKr: String, nameEn: String, url: String, imageURL: String) {
        let uuid = UUID().uuidString
        
        let app = FBLinkModel(id: uuid, name: name, nameKr: nameKr, nameEn: nameEn, url: url, imageURL: imageURL)
        
        do {
            let data = try JSONEncoder().encode(app)
            let jsonString = String(data: data, encoding: .utf8)
            if let jsonData = jsonString?.data(using: .utf8) {
                
                // JSON To Dic
                if let jsonDic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? Dictionary<String, String> {
                    print("JSON Dictionary: \(jsonDic)")
                    
                    Firestore.firestore().collection("link-Widgets").addDocument(data: jsonDic)
                    
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}


