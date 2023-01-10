//
//  KogetApp.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/10.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //MARK: Firebase Configuration
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

@main
struct KogetApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainWidgetView()
                .onOpenURL { url in
                    maybeOpenedFromWidget(urlString: url.absoluteString)
                }
        }
    }
    
    func handlingURL(url: String) -> URL {
        let urlString = url.deletingPrefix(SCHEME_LINK)
        
        return URL(string: urlString)!
    }
    
    //MARK: Deeplink 처리
    /// 위젯 scheme을 확인하고 deepLink를 엽니다.
    private func maybeOpenedFromWidget(urlString: String) {
        print("‼️위젯으로 앱을 열었습니다. ")
        
        let url = URL(string: "\(urlString.deletingPrefix(SCHEME_LINK))")!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
