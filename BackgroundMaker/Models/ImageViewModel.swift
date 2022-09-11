//
//  ImageViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import RxSwift
import Lottie

class ImageViewModel {
    
    static let shared = ImageViewModel()
    
    /// 소스포토 Observable (임시로 저장)
    var sourcePhotoSubject = BehaviorSubject<UIImage?>(value: nil)
    var sourcePhoto: Observable<UIImage?> {
        return editingPhotoSubject.asObserver()
    }
    
    /// 편집중인 Observable
    var editingPhotoSubject = BehaviorSubject<UIImage?>(value: nil)
    var editingPhoto: Observable<UIImage?> {
        return editingPhotoSubject.asObserver()
    }
    
    /// 배경사진 Observable
    var backgroundPhotoSubject = BehaviorSubject<UIImage?>(value: nil)
    var backgroundPhoto: Observable<UIImage?> {
        return editingPhotoSubject.asObserver()
    }
    
    func updateImage(photo: UIImage?, imageView: UIImageView) {
        imageView.image = photo
    }
    
    func makeLottieAnimation(named animationName: String, targetView: UIView, targetVC: UIViewController, size: CGSize) -> AnimationView {
        let animationView = AnimationView(name: animationName)
        animationView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        animationView.center = targetView.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        targetView.addSubview(animationView)
        
        return animationView
    }

}
