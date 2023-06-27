//
//  HomeWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

class HomeWidgetViewModel: ObservableObject {
    
    @Published var targetWidget: DeepLink?
    @Published var widgets = [DeepLink]()
    
    init() {
        fetchAllWidgets()
    }
    
    func fetchAllWidgets() {
        self.widgets = WidgetCoreData.shared.linkWidgets
    }
    
}
