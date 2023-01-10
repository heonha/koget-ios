//
//  SceneDelegate.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/05.
//

import SwiftUI
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        FirebaseApp.configure()
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .clear
        let mainViewController = UIHostingController(rootView: MainWidgetView())
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        // 이 메소드를 사용하여 UIWindow `window`를 선택적으로 구성하고 제공된 UIWindowScene `scene`에 연결합니다.
        // 스토리보드를 사용하는 경우 `window` 속성이 자동으로 초기화되어 장면에 연결됩니다.
        // 이 델리게이트는 연결 장면이나 세션이 새롭다는 것을 의미하지 않습니다(대신 `application:configurationForConnectingSceneSession` 참조).
        
        
    }
    
    
    
}

//MARK: - 위젯으로 들어오는 요청 처리
extension SceneDelegate {
    
    // 앱이 위젯을 통해 열렸는지 확인 하고 URL을 전달합니다.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        /*
         <scheme>://<host>
         starbucks://home
         starbucks://scan
         */
        
        // url: widget-deeplink://shpayfan-touchpay://touch
        // scheme: Optional("widget-deeplink")
        // host: Optional("shpayfan-touchpay")
        // path: //touch
        
        
        var url: URL?
        var host: String?
        
        // URL: widget-deeplink://shpayfan-touchpay://touch
        
        guard let urlContext = URLContexts.first else {return}
        
        print("URL Context : \(URLContexts.first!)")
        print("scheme: \(String(describing: urlContext.url.scheme))")
        print("TEST: \(urlContext.url.absoluteString)")
        
        let urlSwitch: String = urlContext.url.absoluteString
        
        if urlSwitch == SCHEME_OPEN {
            print("위젯 선택 위젯이 클릭 됨!")
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        } else {
            let deepLinkHeader = SCHEME_LINK
            print("url: \(urlContext.url.absoluteURL.absoluteString)")
            url = urlContext.url.absoluteURL
            print("scheme: \(String(describing: urlContext.url.scheme))")
            print("host: \(String(describing: urlContext.url.host))")
            let handler = url!.absoluteString.deletingPrefix(deepLinkHeader)
            
            host = handler
            print("path: \(urlContext.url.path)")
            print("components: \(urlContext.url.pathComponents)")
            
            maybeOpenedFromWidget(urlContexts: URLContexts, host: host)
        }
    }
    
    // func urlHandling(url: String) {
    //     let deepLinkHeader = "widget-deeplink://"
    //     let handler = url.deletingPrefix("\(deepLinkHeader)")
    // }
    //
    
    
    
    //MARK: Deeplink 처리
    /// 위젯 scheme을 확인하고 deepLink를 엽니다.
    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>, host: String?) {
        print("‼️위젯으로 앱을 열었습니다. ")
        
        // 뒤에 Host를 통해 딥링크를 실행합니다.
        guard let host = host else { return }
        
        let url = URL(string: "\(host)")!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}


extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}



