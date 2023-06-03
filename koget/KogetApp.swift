//
//  KogetApp.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/10.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UITableView.appearance().backgroundColor = .systemBackground

        return true
    }
}

@main
struct KogetApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var coreData = DeepLinkManager.shared
    @ObservedObject var appStateConstant = AppStateConstant.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appStateConstant)
                .environmentObject(coreData)
                .tint(AppColor.Label.first.opacity(0.75))
                .onOpenURL { url in
                    maybeOpenedFromWidget(urlString: url.absoluteString)
                }
        }
    }

    //MARK: Deeplink 처리
    /// 위젯 scheme을 확인하고 deepLink를 엽니다.
    func maybeOpenedFromWidget(urlString: String) {
         print("‼️위젯으로 앱을 열었습니다. ")
        let separatedURL = urlString.split(separator: WidgetConstant.idSeparator, maxSplits: 1)
        let url = String(separatedURL[0]).deletingPrefix(WidgetConstant.mainURL)
        let id = String(separatedURL[1])
        
        coreData.linkWidgets.forEach { deepLink in
            if deepLink.id?.uuidString == id {
                deepLink.runCount += 1
                coreData.saveData()
                coreData.loadData()

                return
            }
        }
        // print(id)
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }

        // 기본 구분 기호는 배경과 동일한 색상을 사용합니다.
        // 동일하지만 새롭도록 하려면(예: 빨간색)
        // 아래와 같이 사용됩니다. 그렇지 않으면 사용자 정의 구분자가 필요합니다.
        // set { super.backgroundColor = .red }

    }
}
