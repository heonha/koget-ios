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
        
        var bgMenuButton: UIButton = {

            let image = UIImage(systemName: "drop")!
            let button = viewModel.makeButtonWithImageWithTarget(image: image, action: #selector(bgBlurAction), target: self)
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .normal)
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .selected)
            button.adjustsImageWhenHighlighted = false
            return button
        }()
        
        var bgColorButton: UIButton = {

            let image = UIImage(systemName: "paintpalette")!
            let button = viewModel.makeButtonWithImageWithTarget(image: image, action: #selector(bgColorAction), target: self)
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .normal)
            button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .selected)
            button.adjustsImageWhenHighlighted = false
            return button
        }()
        
        bgView.centerStackView.addArrangedSubview(bgMenuButton)
        bgView.centerStackView.addArrangedSubview(bgColorButton)


    }
    
    /// `배경화면 블러` 액션
    @objc func bgBlurAction(sender: UIButton) {
        if self.colorSlider.isHidden == false {
            self.colorSlider.isHidden = true
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
            if self.colorSlider.isHidden == true {
                ImageViewModel.shared.backgroundPhotoSubject.onNext(nil)
                self.colorSlider.isHidden = false
            } else {
                self.colorSlider.isHidden = true
            }
        }
    }
    
    @objc func nilAction() {
        
    }

}
