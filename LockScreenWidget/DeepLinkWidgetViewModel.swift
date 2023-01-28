//
//  DeepLinkWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/28.
//

import SwiftUI
import CoreData


class DeepLinkWidgetViewModel: ObservableObject {
    
    static let shared = DeepLinkWidgetViewModel()
    
    @Published var linkWidgets: [DeepLink] = WidgetCoreData.shared.linkWidgets
    
    
    private init() {
        
    }
    
    
}
