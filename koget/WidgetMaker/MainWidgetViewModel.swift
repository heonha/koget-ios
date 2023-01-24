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
        
    static let shared = MainWidgetViewModel()
    
    private init() {
        
    }
    
    
}
