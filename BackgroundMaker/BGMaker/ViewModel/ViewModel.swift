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
        button.addAction(action, for: .touchUpInside)

        makeLayerShadow(to: button.layer)
        
        return button
    }
    
    /// 이미지와 타겟이 있는 버튼
    func makeButtonWithImageWithTarget(image: UIImage,
                                       action: Selector?, target: UIViewController) -> UIButton {
        let button = UIButton()
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .selected)

        if let actionCheck = action {
            button.addTarget(target, action: action!, for: .touchDown)
        }

        makeLayerShadow(to: button.layer) // 그림자 추가
        
        return button
    }
    
    /// layer에 그림자를 만듭니다.
    func makeLayerShadow(to layer: CALayer, color: UIColor = UIColor.black, radius: CGFloat = 3, offset: CGFloat = 1, opacity: Float = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: offset, height: offset)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
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
    
    
    func makeMenuButton(button: UIButton, actions: [UIAction], title: String) {
        
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(title: title, options: .displayInline, children: [])
        button.addAction(UIAction { [weak button] (action) in
            button?.menu = button?.menu?.replacingChildren(actions)
            
        }, for: .menuActionTriggered)
    }
    
    func makeImageView(image: UIImage? = nil, contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.backgroundColor = .clear
        iv.image = image
        return iv
    }
    
    
    //MARK: - Label
    
    
    func makeLabel(text: String, color: UIColor = .white,
                   fontSize: CGFloat = 13, fontWeight: UIFont.Weight, alignment: NSTextAlignment = .center) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.textAlignment = alignment
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        
        return label
    }
    
    /// 위젯 스타일 버튼입니다.
    /// > 기본셋
    /// - target: UIViewController, action: Selector,
    /// - title: String,
    /// - titleColor: UIColor = .white,
    /// - fontSize: CGFloat = 18,
    /// - weight: UIFont.Weight = .bold,
    /// - backgroundColor: UIColor = AppColors.buttonPurple
    func makeButtonForWidgetHandler(
        target: UIViewController, action: Selector,
        title: String,
        titleColor: UIColor = .white,
        fontSize: CGFloat = 18,
        weight: UIFont.Weight = .bold,
        backgroundColor: UIColor = AppColors.buttonPurple
    ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attribute = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight)]
        )
        button.setAttributedTitle(attribute, for: .normal)
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(target, action: action, for: .touchDown)
        
        ViewModel.shared.cropCornerRadius(view: button)
        ViewModel.shared.makeLayerShadow(to: button.layer)
        
        return button
    }
    
    func setAttibuteTitleForButton(title: String, button: UIButton, fontSize: CGFloat = 18, weight: UIFont.Weight = .bold) {
        let attribute = NSAttributedString(
            string: title,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight)]
        )
        button.setAttributedTitle(attribute, for: .normal)
    }
    
    func makeAlert(alertTitle: String, alertMessage: String, actions: [UIAlertAction]? ) -> UIAlertController {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        return alert
    }
    
    
    func getImageRatio(image: Data?, targetWidthMultiply: CGFloat) -> CGSize {
        let item = image
        
        let image = UIImage(data: item ?? Data()) ?? UIImage(named:"questionmark.circle")
        
        let itemSize = image!.size
        
        let screenSize = UIScreen.main.bounds
        let targetWidth = screenSize.width * targetWidthMultiply
        
        
        let itemRatio = targetWidth / image!.size.width
        let spacing: CGFloat = 16
        
        // x = 기기 높이 * 이미지 너비 / 기기 너비
        
        let imageSize: CGSize = CGSize(width: itemSize.width * itemRatio - spacing, height: itemSize.height * itemRatio - spacing)
        
        return imageSize
    }
    

}
