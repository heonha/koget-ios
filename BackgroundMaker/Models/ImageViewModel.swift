//
//  ImageViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import RxSwift

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
    

}
