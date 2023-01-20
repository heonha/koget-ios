//
//  AdminAuthModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI
import FirebaseAuth

class AdminAuthModel: ObservableObject {
    
    @Published var userSession: User?
    
    static let shared = AdminAuthModel()
    
    private init() {
        userSession = Auth.auth().currentUser
        print(userSession)
    }
    
}
