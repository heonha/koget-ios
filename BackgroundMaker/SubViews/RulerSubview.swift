//
//  RulerSubview.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/28.
//

import UIKit
import RulerView
import SnapKit
import RxSwift
import RxCocoa

class RulerSubview: UIView {
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        print("DEBUG: Touch: \(touch)")
        print("DEBUG: Touches: \(touches)")
        print("DEBUG: event: \(event)")

    }
    

    //MARK: - LayoutSubview
    
}
