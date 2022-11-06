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
    
    func switchBlurSubview() {
        
        if rulerViewSwitch == .edgeBlur {
            edgeBlurSliderView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(traySubView)
                make.height.equalTo(50)
            }
        }
        
        else if rulerViewSwitch == .backgroundBlur {
            edgeBlurSliderView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(traySubView.snp.top)
                make.height.equalTo(50)
            }
        }

    }
    
    /// Ruler의 값을 관찰하는 Delegate입니다
    func rulerValueChanged(_ ruler: RulerView, value: Float) {
        
        if rulerViewSwitch == .edgeBlur {
            print("DEBUG: RulerValue : \(value)")
            // 3~10
            if value > 3.0 {
                let inset: CGFloat = CGFloat(value) * 4.0
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: inset)
            } else {
                EditImageModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: 0)
            }
        }
        
        if rulerViewSwitch == .backgroundBlur {
            print("DEBUG: RulerValue : \(value)")
            // 3~10
            if value > 3.0 {
                let radius: CGFloat = CGFloat(value) * 4.0
                let bluredImg = EditImageModel.shared.makeBlurImage(image: self.bgImageView.image!, radius: radius)
                EditViewModel.shared.backgroundPhotoSubject.onNext(bluredImg)
            } else {
                
                var sourceImage = UIImage()
                EditViewModel.shared.sourcePhotoSubject.subscribe { image in
                    sourceImage = image ?? UIImage(named: "questionmark.circle")!
                }.dispose()
                
                let image = EditImageModel.shared.makeBlurImage(image: sourceImage, radius: 0)
                EditViewModel.shared.backgroundPhotoSubject.onNext(image)

            }
        }
    }
}


