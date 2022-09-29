//
//  ViewController.swift
//  BMUITester
//
//  Created by HeonJin Ha on 2022/09/28.
//

import UIKit
import RulerView
import SnapKit

class RulerViewUITester: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        makeRulerSliderView() // 룰러뷰(눈금뷰) 정의
        
        
    }
}


extension RulerViewUITester: RulerDelegate {
    
    func makeRulerSliderView() {
        
        let rulerView = RulerView()

        view.addSubview(rulerView)
        rulerView.delegate = self
        
        rulerView.backgroundColor = .black
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        
        rulerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()

            make.height.equalTo(50)
        }
    }
    
    
    func rulerValueChanged(_ ruler: RulerView, value: Float) {
        print("룰러뷰 체인지 됨")
        print("DEBUG: RulerValue : \(value)")

    }
    
    
}
