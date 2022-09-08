//
//  ViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit


struct ViewModel {
    
    static let shared = ViewModel()
    
    
    
    /// 현재 View를 캡쳐하고 Image를 반환합니다.
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
    
    
}
