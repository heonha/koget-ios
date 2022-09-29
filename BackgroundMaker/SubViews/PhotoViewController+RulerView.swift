//
//  PhotoViewController+RulerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/28.
//

import RulerView
import SnapKit
import UIKit

extension PhotoViewController: RulerDelegate {
    
    /// 블러를 조절할 수 있는 뷰를 그립니다.
    func makeBlurSubview() {

        let contentBGView = UIView()
        let rulerView = RulerView()
        
        view.addSubview(blurSubview)
        
        blurSubview.translatesAutoresizingMaskIntoConstraints = false
        blurSubview.isHidden = true
        blurSubview.backgroundColor = .clear
        
        blurSubview.addSubview(contentBGView)
        contentBGView.translatesAutoresizingMaskIntoConstraints = false
        contentBGView.backgroundColor = .black
        contentBGView.alpha = 0.3
        
        blurSubview.addSubview(rulerView)
        rulerView.backgroundColor = .clear
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        rulerView.delegate = self
        
        blurSubview.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(trayView.snp.top)
            make.height.equalTo(50)
        }
        
        contentBGView.snp.makeConstraints { make in
            make.edges.equalTo(blurSubview)
        
        }
        
        rulerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(blurSubview)
            make.bottom.equalTo(blurSubview).inset(3)
        }
    }
    
    
    /// 블러버튼을 눌렀을 때의 동작입니다.
    func imageBlurAction() {
        
        blurSubview.isHidden = !blurButton.isSelected
        // self.isBlured = !self.isBlured // 토글

        if blurSubview.isHidden == false {
            blurSubview.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.blurSubview.alpha = 1
            }
        } else {
            self.blurSubview.alpha = 1
            UIView.animate(withDuration: 0.2) {
                self.blurSubview.alpha = 0
            }
        }
    }
    
    /// Ruler의 값을 관찰하는 Delegate입니다
    func rulerValueChanged(_ ruler: RulerView, value: Float) {
        print("룰러뷰 체인지 됨")
        print("DEBUG: RulerValue : \(value)")
        // 3~10
        if value > 3.0 {
            let inset: CGFloat = CGFloat(value) * 4.0
            
            ImageEditModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: inset)
        } else {
            ImageEditModel.shared.makeImageRoundBlur(imageView: self.mainImageView, insetY: 0)
        }
    }
    
}
