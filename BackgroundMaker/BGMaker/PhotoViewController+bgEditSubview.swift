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
            make.bottom.equalTo(bottomView.snp.top)
        }

    }
    
    /// `배경화면 블러` 액션
    @objc func bgBlurAction(sender: UIButton) {
        sender.showAnimation {
            ImageViewModel.shared.editingPhotoSubject
                .subscribe { image in
                    let bluredImage = image?.blurImage(radius: 40)
                    ImageViewModel.shared.backgroundPhotoSubject.onNext(bluredImage)
                }.dispose()
        }
    }

    
    func configureSubmenuBackground() {
        
        view.addSubview(trayRootView)
        trayRootView.snp.makeConstraints { make in
            make.bottom.equalTo(view)
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-65)
        }
        
        let subviewHeight: CGFloat = 50
        view.addSubview(traySubView)
        traySubView.snp.makeConstraints { make in
            make.bottom.equalTo(trayRootView.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(subviewHeight)
        }

    }

}
