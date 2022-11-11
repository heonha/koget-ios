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
        
        print(ruler)
        
        if ruler == self.edgeRulerView {

            // 3~10
            if value > 3.0 {
                print("\(value)")
                let inset: CGFloat = CGFloat(value) * 4.0
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: inset)
            } else {
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: 0)
            }
            self.edgeBlurValue = value
        }
        
        if ruler == self.bgRulerView {
            
            // 3~10
            if value > 3.0 {
                print("\(value)")

                let radius: CGFloat = CGFloat(value) * 4.0
                let bluredImg = EditImageModel.shared.makeBlurImage(image: self.bgImageView.image!, radius: radius)
                EditViewModel.shared.backgroundPhotoSubject.onNext(bluredImg)
            } else {
                
                var sourceImage = UIImage()
                EditViewModel.shared.sourcePhotoSubject
                    .distinctUntilChanged()
                    .subscribe { image in
                    sourceImage = image ?? UIImage(named: "questionmark.circle")!
                }.dispose()
                
                let image = EditImageModel.shared.makeBlurImage(image: sourceImage, radius: 0)
                EditViewModel.shared.backgroundPhotoSubject.onNext(image)
                
                self.bgBlurValue = value

            }
        }
    }
}


