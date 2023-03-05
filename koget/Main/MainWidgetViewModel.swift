//
//  MainWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI

class MainWidgetViewModel: ObservableObject {
    
    //MARK: Published Variables
    // @Published var makeSuccessful: Bool = false
    // @Published var deleteSuccessful: Bool = false
    @Published var isEditingMode: Bool = false
    @Published var selection = [DeepLink]()
    @Published var isEditMode: EditMode = .inactive

    //MARK: User Defaults
    @AppStorage("isGridView") var isGridView = false
    @AppStorage("FirstRun") var isFirstRun = true
    
    static let shared = MainWidgetViewModel()
    
    private init() {

    }
    
    func openURL(urlString: String) {
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url.absoluteURL)

        } else {
            // print("URL Open Error: \(urlString)")
            return
        }
        
    }
    
    func checkLinkType(url: String) -> LinkType {
        if url.lowercased().contains("http://") || url.lowercased().contains("https://") {
            return LinkType.web
        } else {
            return LinkType.app
        }
    }
    
    func maybeOpenedFromWidget(urlString: String) {
        // print("‼️앱에서 링크를 열었습니다. ")

        let separatedURL = urlString.split(separator: idSeparator, maxSplits: 1)
        let url = String(separatedURL[0]).deletingPrefix(schemeToAppLink)
        let id = String(separatedURL[1])
        
        WidgetCoreData.shared.linkWidgets.contains { deepLink in
            if deepLink.id?.uuidString == id {
                deepLink.runCount += 1
                WidgetCoreData.shared.saveData()
                WidgetCoreData.shared.loadData()
                return true
            } else {
                return false
            }
        }

        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        
        return

    }

    func deleteItem(completion: @escaping() -> Void) {
        for widget in selection {
            WidgetCoreData.shared.deleteData(data: widget)
        }

        completion()

    }

}
