//
//  CustumRulerView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/03.
//

import UIKit
import RulerView
import SnapKit
import SwiftUI

class CustomRulerView: UIView {
    
    let view = UIView()
    let rulerView: RulerView = {
        let rv = RulerView()
        return rv
    }()
    
    let mainView = UIView()
    var title: String!
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.alpha = 0.5
        
        return label
    }()
    
    var delegate: RulerDelegate!
    
    init(title: String, delegate: RulerDelegate) {
        self.title = title
        self.delegate = delegate
        super.init(frame: .zero)
        self.titleLabel.text = self.title
        configureUI()
        makeBlurSubview()
        self.alpha = 0

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func reloadTitleLabel() {
        self.titleLabel.text = self.title
    }
    
    
    /// 블러를 조절할 수 있는 뷰를 그립니다.
    func makeBlurSubview() {
        
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .clear
        
        mainView.addSubview(rulerView)
        rulerView.backgroundColor = .clear
        rulerView.translatesAutoresizingMaskIntoConstraints = false
        rulerView.delegate = delegate

        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rulerView.snp.makeConstraints { make in
            make.edges.equalTo(mainView).inset(4)
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(mainView)
            make.height.equalTo(17)
        }

    }
}

 
