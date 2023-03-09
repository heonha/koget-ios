//
//  BuiltInWidgetModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import Foundation

final class WidgetAssetViewModel: ObservableObject {
    
    @Published var isOnlyInstalledApp: Bool = false
    @Published var data: [LinkWidget] = []
    @Published var searchResults: [LinkWidget] = []
    
    init() {
        data = LinkWidgetModel.shared.builtInApps
    }
    
    func canOpenApp(_ canOpen: Bool) -> Double {
        if canOpen {
            return 1.0
        } else {
            return 0.25
        }
    }
    
    func fetchData(isOnlyInstall: Bool) {
        if isOnlyInstall {
            data = data.filter({ widget in
                widget.canOpen == true
            })
        } else {
            data = LinkWidgetModel.shared.builtInApps
        }
        
    }
    
    func fetchSearchData(searchText: String) {
        searchResults = data.filter({ widget in
            widget.name.lowercased().contains(searchText.lowercased()) ||
            widget.nameKr.lowercased().contains(searchText.lowercased()) ||
            widget.nameEn.lowercased().contains(searchText.lowercased())
        })
    }
    
    func fetchOnlyInstalledApp(searchText: String) {
        searchResults = data.filter({ widget in
            widget.canOpen == true ||
            widget.name.lowercased().contains(searchText.lowercased()) ||
            widget.nameKr.lowercased().contains(searchText.lowercased()) ||
            widget.nameEn.lowercased().contains(searchText.lowercased())
        })
    }
}
