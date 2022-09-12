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
    var backgroundPhotoSubject = ReplaySubject<UIImage?>.create(bufferSize: 5)
    var backgroundPhoto: Observable<UIImage?> {
        return backgroundPhotoSubject.asObserver()
    }
    
    /// 이미지를 업데이트 합니다.
    func updateImage(photo: UIImage?, imageView: UIImageView) {
        imageView.image = photo
    }
    
    /**
     `Lottie Animation을 생성하는 메소드입니다.`
     >  Properties
     - `named:` 애니메이션 JSON 의 이름입니다
     - `targetView:` Animation View를 포함시킬 뷰입니다.
     - `targetVC` : Animation을 넣을 Vie∫w객체 입니다.
     - `size` : 애니메이션 개체의 사이즈입니다.
     - `loopMode`: 애니메이션의 루프를 설정합니다. (기본값 Loop)
     */
    func makeLottieAnimation(named animationName: String, targetView: UIView, size: CGSize, loopMode: LottieLoopMode = .loop) -> AnimationView {
        let animationView = AnimationView(name: animationName)
        animationView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        animationView.center = targetView.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        targetView.addSubview(animationView)
        
        return animationView
    }
}
