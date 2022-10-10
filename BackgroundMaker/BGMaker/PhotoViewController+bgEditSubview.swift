//
//  PhotoViewController+bgEditSubview.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/29.
//

import UIKit
import SnapKit
import RxSwift
import RulerView


extension PhotoViewController {

    /// `배경화면 편집` 버튼을 누르면 생성되는 Subview를 구성합니다.
    func makeBGEditView(view bgView: BottomMenuView) {
        
        view.addSubview(bgView)
        bgView.isHidden = true
        
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(trayView.snp.top)
        }

    }
    
    /// `배경화면 블러` 액션
    @objc func bgBlurAction(sender: UIButton) {
        if self.colorPickerView.isHidden == false {
            self.colorPickerView.isHidden = true
        }
        
        sender.showAnimation {
            ImageViewModel.shared.editingPhotoSubject
                .subscribe { image in
                    let bluredImage = image?.blurImage(radius: 40)
                    ImageViewModel.shared.backgroundPhotoSubject.onNext(bluredImage)
                }.dispose()
        }
    }
    
    /// `배경화면 컬러` 액션
    @objc func bgColorAction(sender: UIButton) {
        
        sender.showAnimation {
            if self.colorPickerView.isHidden == true {
                self.colorPickerView.isHidden = false
            } else {
                self.colorPickerView.isHidden = true
            }
        }
    }
    
    @objc func nilAction() {
        
    }

}
