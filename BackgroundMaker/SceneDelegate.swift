//
//  SceneDelegate.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // maybeOpenedFromWidget(urlContexts: connectionOptions.urlContexts, scheme: nil)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        let mainViewController = HomeViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)

        window?.rootViewController = WidgetTestVC()
        window?.makeKeyAndVisible()
        
        // 이 메소드를 사용하여 UIWindow `window`를 선택적으로 구성하고 제공된 UIWindowScene `scene`에 연결합니다.
        // 스토리보드를 사용하는 경우 `window` 속성이 자동으로 초기화되어 장면에 연결됩니다.
        // 이 델리게이트는 연결 장면이나 세션이 새롭다는 것을 의미하지 않습니다(대신 `application:configurationForConnectingSceneSession` 참조).
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }
    
    //MARK: - Depp Link
    
    // 앱이 위젯을 통해 열렸는지 확인 하고 URL을 전달합니다.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
     
        /*
         <scheme>://<host>
         starbucks://home
         starbucks://scan
         */
        var url: URL?
        var host: String?
        
        print("URL Context : \(URLContexts.first!)")
        
        for context in URLContexts {
            print("url: \(context.url.absoluteURL)")
            url = context.url.absoluteURL
            print("scheme: \(context.url.scheme)")
            print("host: \(context.url.host)")
            host = context.url.host!
            print("path: \(context.url.path)")
            print("components: \(context.url.pathComponents)")
        }
        
        maybeOpenedFromWidget(urlContexts: URLContexts, host: host)
    }

    /// 위젯 scheme을 확인하고 deepLink를 엽니다.
    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>, host: String?) {
        guard let _: UIOpenURLContext = urlContexts.first(where: { $0.url.scheme == "widget-deeplink"}) else { return }
        print("🚀 Launched from widget")
        
        guard let host = host else { return }
        
            let url = URL(string: "\(host)://")!
            print("Scheme! -> \(host)")

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }


}


