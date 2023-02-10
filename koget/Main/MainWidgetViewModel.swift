//
//  MainWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI


class MainWidgetViewModel: ObservableObject {
    
    @Published var makeSuccessful: Bool = false
    @Published var deleteSuccessful: Bool = false
    
    @AppStorage("FirstRun") var isFirstRun = true
    
    
    @Published var isEditingMode: Bool = false

        
    static let shared = MainWidgetViewModel()
    
    private init() {
        
    }
    
    func openURL(urlString: String) {
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url.absoluteURL)

        } else {
            print("URL Open Error: \(urlString)")
            return
        }
        
    }
    
    
}
