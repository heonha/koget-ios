//
//  MainContainerViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/26.
//

import UIKit
import SwiftUI
import SwipeableTabBarController

class MainContainerViewController: SwipeableTabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarUI()
        configureSwipeableTabBar()
        configureTabbarContrents()

    }
    
    // MARK: UI 구성
    private func configureTabBarUI() {
        tabBar.backgroundColor = AppColors.normalDarkGrey
        tabBar.tintColor = AppColors.deepPurple
        tabBar.isTranslucent = true
    }
    
    
    // MARK: Swipe Library 구성
    private func configureSwipeableTabBar() {
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
        swipeAnimatedTransitioning?.animationDuration = 0.15
        tapAnimatedTransitioning = nil
    }
    
    // MARK: Contents 구성
    private func configureTabbarContrents() {
        
        let aVC = MainWallpaperViewController()
        // let bVC = WidgetViewController()
        let bVC = UIHostingController(rootView: MainWidgetView())
        
        // 하단 탭아이콘 구성.
        aVC.setTabBarImage(imageName: "rectangle.stack.badge.plus", title: "배경화면")
        bVC.setTabBarImage(imageName: "cursorarrow.and.square.on.square.dashed", title: "위젯")
        
        let aNC = UINavigationController(rootViewController: aVC)
        // let bNC = UINavigationController(rootViewController: bVC)
        
        
        let tabBarList = [aNC, bVC]
        viewControllers = tabBarList
        
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    

    
}


extension UIViewController {
    func setTabBarImage(imageName: String, title: String) {
        // MARK: TabBar 하단 Object 만들기.
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
