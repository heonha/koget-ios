//
//  GuestAuthService.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/22.
//

import SwiftUI
import FirebaseAuth

class GuestAuthService: ObservableObject {
    
    @Published var guestSession: User?
    @Published var isAnonymous: Bool?
    
    init() {
        guestSignin()
    }
    
    func guestSignin() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                // debugPrint("Guest Login Error -> \(error.localizedDescription)")
            } else {
                guard let user = authResult?.user else { return }
                // print(user.uid)
                self.guestSession = authResult?.user
                self.isAnonymous = user.isAnonymous  // true
            }

        }
    }
    
}
