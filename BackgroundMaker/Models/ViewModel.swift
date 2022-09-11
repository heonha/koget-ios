//
//  ViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit


struct ViewModel {
    static let shared = ViewModel()
    
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
        let buttonImage = UIImage(systemName: systemName)?.withRenderingMode(.automatic)
        let button = UIBarButtonItem(image: buttonImage, style: .plain, target: target, action: selector)
        button.isEnabled = isHidden
        button.tintColor = .label
        
        return button
    }
    
    
}
