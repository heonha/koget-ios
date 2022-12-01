//
//  BuiltInWidgetModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import Foundation

final class FilterWidgetModel: ObservableObject {
    
    @Published var data: [LinkWidget] = []
    @Published var searchResults: [LinkWidget] = []
    
    init() {
        data = DefaultWidgetManager.shared.getWidgetData()
    }

    
}
