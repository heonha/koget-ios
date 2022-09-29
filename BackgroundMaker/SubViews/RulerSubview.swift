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
    
    var selectedType: SubmenuType = .none
    
    var btnFirstReponderSubject = PublishSubject<SubmenuType>.init()
    lazy var btnFirstReponderObservable = btnFirstReponderSubject.asObservable()
        .subscribe { button in
        
    } onError: { error in
        print("DEBUG: BtnFirstResponder Error \(error.localizedDescription)")

    } onCompleted: {
        print("Completed")
    } onDisposed: {
        print("btnFirstReponderSubject Disposed")
    }


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
    

    
    func blurBtnAction() {
        btnFirstReponderSubject.onNext(.blur)

    }
    
    func bgBtnAction() {
        btnFirstReponderSubject.onNext(.editBackground)
    }
    
    func btnHiddenManager() {
        
    }
    // 1. 블러 버튼을 눌렀다. -> blur button Tapped
    // 2. 블러 슬라이더가 표시된다. -> rulerView.isHidden = false
    // 3. 배경변경 버튼을 누른다.  -> bgButton Tapped
    // 4. 블러 슬라이더가 숨겨진다, 배경변경 뷰가 표시된다.
    // if buttontapped != blurBtn ? rulerView.isHidden = true, BGView.isHidden = false : 동작없음


    
    //MARK: - LayoutSubview
    
}
