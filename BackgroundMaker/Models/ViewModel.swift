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
    
    /// 현재 ViewController를 캡쳐하고 Image를 반환합니다. (withoutView: 스크린 찍을 동안 숨길 뷰)
    func takeScreenViewCapture(withoutView: [UIView]?, target: UIViewController) -> UIImage? {
        withoutView?.forEach({ views in
            views.isHidden = true
        })
        
        let captureImage = target.view.renderToImage(afterScreenUpdates: true)
        
        withoutView?.forEach({ views in
            views.isHidden = false
        })
        return captureImage
    }
    
    /// 해당 하는 뷰만 캡쳐합니다.
    func takeViewCapture(targetView: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetView.bounds.size)
        let image = renderer.image { ctx in
            targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithSystemImage(systemName: String, selector: Selector, isHidden: Bool = true, target: UIViewController) -> UIBarButtonItem {
        let renderedImage = UIImage(systemName: systemName)!.withTintColor(.label, renderingMode: .alwaysOriginal).applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 23), scale: .default))
        
        let button = UIBarButtonItem(image: renderedImage, style: .plain, target: target, action: selector)
        
        return button
    }
    
    
    func makeBarButtonWithTitle(title: String, selector: Selector, isEnabled: Bool = true, target: UIViewController) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        button.isEnabled = isEnabled
        button.tintColor = .label
        
        return button
    }
    
    
    func makeButtonWithTitle(title: String, action: UIAction, target: UIViewController) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        // button.layer.cornerRadius = 8
        button.addAction(action, for: .touchDown)
        button.setTitleColor(.label, for: .normal)
        makeButtonShadow(to: button)

        return button
    }
    
    func makeButtonWithImage(image: UIImage, action: UIAction, target: UIViewController) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        // button.layer.cornerRadius = 8
        button.addAction(action, for: .touchDown)

        makeButtonShadow(to: button)
        
        return button
    }
    
    // 버튼의 그림자를 만듭니다.
    func makeButtonShadow(to button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 4
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
    
}
