//
//  PhotoViewController+RulerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/28.
//

import RulerView
import SnapKit
import UIKit
import SwiftUI

extension PhotoViewController: RulerDelegate {
    
    /// 블러를 조절할 수 있는 뷰를 그립니다.
    func makeBlurSubview(view mainView: UIView) {

        let rulerView = RulerView()
        
        view.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .clear
        
        mainView.addSubview(rulerView)
        rulerView.backgroundColor = .clear
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        rulerView.delegate = self
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(50)
        }
        
        
        rulerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(edgeBlurSliderView)
            make.bottom.equalTo(edgeBlurSliderView).inset(3)
        }

        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "엣지 블러"
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.white
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.alpha = 0.5
            
            return label
        }()
        
        mainView.addSubview(titleLabel)

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


