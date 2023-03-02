//
//  EditViewModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import RxSwift

class EditViewModel {
    
    //MARK: - Singleton
    static let shared = EditViewModel()

    //MARK: - Init
    private init() {

    }
    
    //MARK: - Async Objects (Rx)
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
        return backgroundPhotoSubject.asObserver()
    }
    
    //MARK: - Methods

    /// 이미지를 업데이트 합니다.
    func updateImage(photo: UIImage?, imageView: UIImageView) {
        imageView.image = photo
    }
    
    /**
     `스크린 사이즈에 따라서 높이를 조절합니다.`
     >
     - `공식 :` imageWidth : imageHeight = screenWidth : x
     - `스크린 너비를 받아서 높이 :` x = imageHeight * screenWidth / imageWidth
     */
    func setImageViews(imageView: UIImageView) {
        guard let imageSize = imageView.image?.size else {return}
        
        /// 스크린 너비에 따른 이미지뷰 높이 구하기
        let screenSize = UIScreen.main.bounds
        let imageHeight = (imageSize.height * screenSize.width) / imageSize.width
        let resizeHeight = (screenSize.height - imageHeight) / 2

        /// 이미지뷰 레이아웃
        imageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
    }
}
