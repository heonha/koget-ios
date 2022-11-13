//
//  MakeWallpaperViewController+RulerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/28.
//

import RulerView
import SnapKit
import UIKit
import SwiftUI
import RxSwift

extension MakeWallpaperViewController: RulerDelegate {
    
    func configureRulerViews() {
        
        
        edgeRulerView.delegate = self
        view.addSubview(edgeRulerView)
        edgeRulerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(50)
        }
        
        view.addSubview(bgRulerView)
        bgRulerView.delegate = self
        bgRulerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(traySubView.snp.top)
            make.height.equalTo(50)
        }
        
    }

    
    /// Ruler의 값을 관찰하는 Delegate입니다
    func rulerValueChanged(_ ruler: RulerView, value: Float) {
        
        if ruler.hashValue == self.edgeRulerView.rulerView.hashValue {

            // 3~10
            if value > 3.0 {
                print("\(value)")
                let inset: CGFloat = CGFloat(value) * 10.0
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: inset)
            } else {
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: 0)
            }
        }
        
        if ruler.hashValue == self.bgRulerView.rulerView.hashValue {
            
            // // 3~10
            // if value > 3.0 {
            //     print("\(value)")
            //
                let radius: CGFloat = CGFloat(value) * 5 // value
                // Value를 받아서 리턴한다.
                let bluredImg = EditImageModel.shared.makeBlurImage(image: self.sourceImage, radius: radius)
                RxImageViewModel.shared.backgroundImageSubject.onNext(bluredImg)
                
                self.bgRulerViewValue = value
                
            // }
            // else {
            //
            //     var sourceImage = UIImage()
            //     RxImageViewModel.shared.sourcePhoto
            //         .subscribe { image in
            //         sourceImage = image ?? UIImage(named: "questionmark.circle")!
            //     }.dispose()
            //
            //     let image = EditImageModel.shared.makeBlurImage(image: sourceImage, radius: 0)
            //     RxImageViewModel.shared.backgroundImageSubject.onNext(image)
            //
            // }
        }
    }
}


