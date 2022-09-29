//
//  UITestContainerVC.swift
//  BMUITester
//
//  Created by HeonJin Ha on 2022/09/29.
//

import UIKit

class UITestContainerVC: UITabBarController {
    
    private let appColor = UIColor(ciColor: .blue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }
    
    // MARK: Setup Views
    private func setupViews() {
        
        let rulerViewVC = RulerViewUITester()
        let sliderVC = SliderUITester()
        let subviewVC = SubviewUITester()

        
        // 하단 탭아이콘 구성.
        rulerViewVC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "ruler")
        sliderVC.setTabBarImage(imageName: "arrow.left.arrow.right", title: "slider")
        subviewVC.setTabBarImage(imageName: "arrow.left.arrow.right", title: "subview")

        let rulerViewNC = UINavigationController(rootViewController: rulerViewVC)
        let sliderNC = UINavigationController(rootViewController: sliderVC)
        let subviewNC = UINavigationController(rootViewController: subviewVC)

        
        rulerViewNC.navigationBar.barTintColor = .systemBackground
        
        let tabBarList = [rulerViewNC, sliderNC, subviewNC]
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
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = appColor
        tabBar.isTranslucent = false
    }
    
}

class AccountSummaryViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemGreen
    }
}
class MoveMoneyViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemOrange
    }
}
class MoreViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemPurple
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
