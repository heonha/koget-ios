//
//  MainContainerViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/26.
//

import UIKit

class MainContainerViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }
    
    // MARK: Setup Views
    private func setupViews() {
        
        let aVC = MainPhotoViewController()
        let bVC = WidgetViewController()
        
        // 하단 탭아이콘 구성.
        aVC.setTabBarImage(imageName: "rectangle.stack.badge.plus", title: "배경화면")
        bVC.setTabBarImage(imageName: "cursorarrow.and.square.on.square.dashed", title: "위젯")
        
        let aNC = UINavigationController(rootViewController: aVC)
        let bNC = UINavigationController(rootViewController: bVC)
        

        
        aNC.navigationBar.barTintColor = .systemBackground
        
        let tabBarList = [aNC, bNC]
        viewControllers = tabBarList
        
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    
    // MARK: - Setup TabBar
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = AppColors.buttonPurple
        tabBar.isTranslucent = false
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
