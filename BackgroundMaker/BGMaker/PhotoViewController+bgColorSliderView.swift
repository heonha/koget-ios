//
//  PhotoViewController+bgColorSliderView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import UIKit
import SnapKit

extension PhotoViewController {

    //MARK: - ColorSlider 셋업

    func makeBGColorSlider() {
        
        view.addSubview(colorSlider)
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        colorSlider.isHidden = true
        colorSlider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(bgSubview.snp.top).offset(-10)
            make.height.equalTo(30)

        }
    }

}
