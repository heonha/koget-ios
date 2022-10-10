//
//  ViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit
import SnapKit

struct ViewModel {
    
    //MARK: - Singleton
    static let shared = ViewModel()

    //MARK: - Init
    private init() {
        
    }

    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithSystemImage(systemName: String, selector: Selector, isHidden: Bool = true, target: UIViewController) -> UIBarButtonItem {
        let renderedImage = UIImage(systemName: systemName)!.withTintColor(.label, renderingMode: .alwaysOriginal).applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23), scale: .default))
        
        let button = UIBarButtonItem(image: renderedImage, style: .plain, target: target, action: selector)
        
        return button
    }
    
    /// 타이틀이 있는 UIBarButton 을 만듭니다.
    func makeBarButtonWithTitle(title: String, selector: Selector, isEnabled: Bool = true, target: UIViewController) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        button.isEnabled = isEnabled
        button.tintColor = .label
        
        return button
    }
    
    /// 타이틀이 있는 UIButton을 만듭니다.
    func makeButtonWithTitle(title: String, action: UIAction, target: UIViewController,
                             backgroundColor: UIColor = .clear, isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addAction(action, for: .touchDown)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = backgroundColor
        button.isEnabled = isEnabled
        makeLayerShadow(to: button.layer)

        return button
    }
    
    func makeButtonWithTitleAndTarget(title: String, action: Selector, target: UIViewController,
                             backgroundColor: UIColor = .clear, isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = backgroundColor
        button.isEnabled = isEnabled
        button.addTarget(target, action: action, for: .touchDown)
        makeLayerShadow(to: button.layer)

        return button
    }
    
    
    /// 이미지가 있는 UIButton을 만듭니다.
    func makeButtonWithImage(image: UIImage, action: UIAction, target: UIViewController) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .selected)
        button.addAction(action, for: .touchDown)

        makeLayerShadow(to: button.layer)
        
        return button
    }
    
    func makeButtonWithImageWithTarget(image: UIImage,
                                       action: Selector, target: UIViewController) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .selected)

        button.addTarget(target, action: action, for: .touchDown)

        makeLayerShadow(to: button.layer)
        
        return button
    }
    
    // 버튼의 그림자를 만듭니다.
    func makeLayerShadow(to layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 4
    }
    
    // 바버튼의 그림자를 만듭니다.
    func makeBarButtonShadow(barButton: UIBarButtonItem, imageView: UIImageView){
        barButton.customView = imageView
        barButton.customView?.layer.shadowColor = UIColor.black.cgColor
        barButton.customView?.layer.shadowOffset = CGSize(width: 1, height: 1)
        barButton.customView?.layer.shadowRadius = 3
        barButton.customView?.layer.shadowOpacity = 4
    }
    

    /// 블러처리를 위해 이미지 뷰의 사이즈를 조절합니다.
    func setImageViews(imageView: UIImageView, imageSize: CGSize?, targetView: UIView) {

        guard let imageSize = imageSize else {return}
        let screenSize = targetView.bounds.size
        
        // 스크린 사이즈에 따라서 높이
        // imageWidth : imageHeight = screenWidth : x
        // x = imageHeight * screenWidth / imageWidth
        
        let imageHeight = (imageSize.height * screenSize.width) / imageSize.width
        let resizeHeight = (screenSize.height - imageHeight) / 2
        print(imageHeight)
 
        // imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // targetView.addSubview(imageView)
        
        imageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
        
    }
    
    
    func barButtonAction(function: Void) -> UIAction {
        let action = UIAction { action in
            function
        }
        return action
    }
    

    
    
    //MARK: - UIView + Utils
    func cropCornerRadius(view: UIView, radius: CGFloat = 10) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    
    func makeMenuButton(button: UIButton, actions: [UIAction]) {
        
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(options: .displayInline, children: [])
        button.addAction(UIAction { [weak button] (action) in
            button?.menu = button?.menu?.replacingChildren(actions)
        }, for: .menuActionTriggered)
        
    }
    
}
