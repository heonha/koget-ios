//
//  HomeWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

class HomeWidgetViewModel: ObservableObject, DisplayAlert {
    
    @Published var targetWidget: DeepLink?
    @Published var widgets: [DeepLink] = []
    @Published var showDetail = false
    @Published var slidedCellIndex: CGFloat = .zero
    private var coredata = WidgetCoreData.shared
    
    init() {
        fetchAllWidgets()
    }
    
    func updateView(){
        self.objectWillChange.send()
    }
    
    func fetchAllWidgets() {
        self.widgets = WidgetCoreData.shared.linkWidgets
    }
    
    func deleteWidget(_ widget: DeepLink) {
        coredata.deleteData(data: widget)
        displayAlertView()
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
