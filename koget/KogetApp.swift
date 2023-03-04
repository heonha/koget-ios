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
        
        //MARK: - Firebase Configuration
        FirebaseApp.configure()
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().tintColor = .black
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.label
        ], for: .normal)
        
        return true
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Add your custom code here
    }
}

@main
struct KogetApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase

    private let coreData = WidgetCoreData.shared
    
    var body: some Scene {

        WindowGroup {
            
            ContentView()
                .onOpenURL { url in
                    maybeOpenedFromWidget(urlString: url.absoluteString)
                }
                .tint(.black)
                .environmentObject(coreData)
                .environment(\.managedObjectContext, coreData.container.viewContext)
                .background(Color.init(uiColor: .secondarySystemBackground))
        }
    }

    //MARK: Deeplink 처리
    /// 위젯 scheme을 확인하고 deepLink를 엽니다.
    func maybeOpenedFromWidget(urlString: String) {
        // print("‼️위젯으로 앱을 열었습니다. ")
        let separatedURL = urlString.split(separator: idSeparator, maxSplits: 1)
        let url = String(separatedURL[0]).deletingPrefix(schemeToAppLink)
        let id = String(separatedURL[1])
        
        coreData.linkWidgets.contains { deepLink in
            if deepLink.id?.uuidString == id {
                deepLink.runCount += 1
                coreData.saveData()
                coreData.loadData()
                return true
            } else {
                return false
            }
        }
        // print(id)
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        
        return

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

        // default separators use same color as background
        // so to have it same but new (say red) it can be
        // used as below, otherwise we just need custom separators
        //
        // set { super.backgroundColor = .red }

    }
}

