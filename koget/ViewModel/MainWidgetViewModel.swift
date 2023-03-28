//
//  MainWidgetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/23.
//

import SwiftUI
import SwiftEntryKit

final class MainWidgetViewModel: ObservableObject {
    
    //MARK: Published Variables
    @Published var isEditingMode: Bool = false
    @Published var selection = [DeepLink]()
    @Published var alertView = UIView()

    //MARK: User Defaults
    @AppStorage("isGridView") var isGridView = false
    @AppStorage("FirstRun") var isFirstRun = true

    static let shared = MainWidgetViewModel()
    
    private init() {
        alertView = setAlertView()
    }

    // Web & App 구분
    func checkLinkType(url: String) -> LinkType {
        if url.lowercased().contains("http://") || url.lowercased().contains("https://") {
            return LinkType.web
        } else {
            return LinkType.app
        }
    }

    // 앱에서 url 실행
    func urlOpenedInApp(urlString: String) {
        let separatedURL = urlString.split(separator: idSeparator, maxSplits: 1)
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

    func deleteItem(completion: @escaping() -> Void) {
        for widget in selection {
            WidgetCoreData.shared.deleteData(data: widget)
        }
        completion()
    }

    func setAlertView() -> UIView {
        return EKMaker.setToastView(title: S.Alert.deleteSuccessTitle, subtitle: S.Alert.deleteSuccessSubtitle, named: "success")
    }

    func displayAlertView() {
        SwiftEntryKit.display(entry: alertView, using: EKMaker.whiteAlertAttribute)
    }

}