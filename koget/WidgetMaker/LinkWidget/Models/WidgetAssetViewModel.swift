//
//  BuiltInWidgetModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import Foundation

final class WidgetAssetViewModel: ObservableObject {
    
    @Published var data: [LinkWidget] = []
    @Published var searchResults: [LinkWidget] = []
    
    init() {
        data = LinkWidgetModel.shared.getWidgetData()
    }
    
    func canOpenApp(_ canOpen: Bool) -> Double {
        if canOpen {
            return 1.0
        } else {
            return 0.25
        }
    }
    
    func fetchSearchData(searchText: String) {
        searchResults = data.filter({ widget in
            widget.appNameEn.lowercased().contains(searchText.lowercased()) ||
            widget.appName.lowercased().contains(searchText.lowercased())
        })
    }

    
}
