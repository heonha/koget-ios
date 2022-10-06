//
//  MenuAnimation.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import UIKit
import SnapKit
import RxSwift


class MenuAnimation: UIView {
    
    
    var titleText: String?
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black

        return label
    }()
    
    //MARK: - Init
    init(title: String) {
        self.titleText = title
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        backgroundColor = .clear
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -
    
    private func configureUI() {
        addSubview(typeLabel)
        typeLabel.text = titleText
        typeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
    
    func configureAnimation() {
        print("configure Tapped")
        
        
        
        
        UIView.animate(withDuration: 3.0) {
            self.typeLabel.alpha = 1
        }
    }
    
    func animationOne() {


    }
    
    func animationTwo() {
        UIView.animate(withDuration: 1.0) {
            self.typeLabel.alpha = 1
        }
    }
    
    
    
}
