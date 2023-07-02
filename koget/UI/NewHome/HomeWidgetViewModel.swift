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
    @Published var showDetail = false
    
    init() {
        fetchAllWidgets()
    }
    
    func fetchAllWidgets() {
        self.widgets = WidgetCoreData.shared.linkWidgets
    }
    
    func urlOpenedInApp(urlString: String) {
        let separatedURL = urlString.split(separator: WidgetConstant.idSeparator, maxSplits: 1)
        let url = String(separatedURL[0]).deletingPrefix(WidgetConstant.mainURL)
        let id = String(separatedURL[1])

        if let deepLink = WidgetCoreData.shared.linkWidgets.first(where: { $0.id?.uuidString == id }) {
            deepLink.runCount += 1
            WidgetCoreData.shared.saveData()
            WidgetCoreData.shared.loadData()
                
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
    
}
