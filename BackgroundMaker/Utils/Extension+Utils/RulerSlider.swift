//
//  RulerSlider.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/28.
//

import RulerView
import UIKit

class RulerSliderVC: UIViewController {
    
    let rulerView = RulerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rulerView)
        rulerView.delegate = self
        
        
    }
}

extension RulerSliderVC: RulerDelegate {
    func rulerValueChanged(_ ruler: RulerView, value: Float) {
        print("룰러뷰 체인지 됨")
    }
    
    
    
}

