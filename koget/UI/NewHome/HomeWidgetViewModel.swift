//
//  HomeWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

class HomeWidgetViewModel: ObservableObject {
    
    @Published var targetWidget: DeepLink?
    @Published var widgets: [DeepLink] = []
    @Published var showDetail = false
    @Published var slidedCellIndex: CGFloat = .zero
    
    init() {
        fetchAllWidgets()
    }
    
    func updateView(){
        self.objectWillChange.send()
    }
    
    func fetchAllWidgets() {
        if !self.widgets.isEmpty {
            print("DEBUG: 빈셀이 아닙니다. 다시업데이트합니다.")
            self.widgets = []
            print("DEBUG: Widget Count \(widgets.count)")
        }
        self.widgets = WidgetCoreData.shared.linkWidgets
        self.objectWillChange.send()
        print("DEBUG: Widget Count(fetched) \(widgets.count)")

    }
    
    func replaceOtherCell() {
        
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
