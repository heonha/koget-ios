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
    func makeBlurSubview(view mainView: UIView) {

        let contentBGView = UIView()
        let rulerView = RulerView()
        
        view.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.isHidden = true
        mainView.backgroundColor = .clear
        
        mainView.addSubview(contentBGView)
        contentBGView.translatesAutoresizingMaskIntoConstraints = false
        contentBGView.backgroundColor = .black
        contentBGView.alpha = 0.3
        
        mainView.addSubview(rulerView)
        rulerView.backgroundColor = .clear
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        rulerView.delegate = self
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(trayView.snp.top)
            make.height.equalTo(50)
        }
        
        contentBGView.snp.makeConstraints { make in
            make.edges.equalTo(edgeBlurSliderView)
        
        }
        
        rulerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(edgeBlurSliderView)
            make.bottom.equalTo(edgeBlurSliderView).inset(3)
        }

        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = " 상하단 흐리게"
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.systemBlue
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.alpha = 0.5
            
            return label
        }()
        
        mainView.addSubview(titleLabel)
            
            

    }
    
    
    /// 블러버튼을 눌렀을 때의 동작입니다.
    func imageBlurAction() {
        
        edgeBlurSliderView.isHidden = !blurButton.isSelected
        // self.isBlured = !self.isBlured // 토글

        if edgeBlurSliderView.isHidden == false {
            edgeBlurSliderView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.edgeBlurSliderView.alpha = 1
            }
        } else {
            self.edgeBlurSliderView.alpha = 1
            UIView.animate(withDuration: 0.2) {
                self.edgeBlurSliderView.alpha = 0
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
