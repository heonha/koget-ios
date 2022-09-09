//
//  TrayView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit
import SnapKit

class BottomMenuView: UIView {
    
    /// 뷰의 배경 레이어 입니다. 컨텐츠와 같이 투명해지지 않도록 배경을 분리합니다.
    let backgroundView = UIView()

    /// 뷰의 컨텐츠가 들어갈 뷰입니다.
    let contentView = UIView()

    /// 기능 버튼이 들어갈 스택뷰입니다.
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupBackgroundView(view: backgroundView)
        setupViewAlphaValue(view: backgroundView, alpha: 0.4)
        setupContentView(view: contentView)
        setupStackView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize: CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 100)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
    /// 컨텐츠의 배경 뷰를 만듭니다.
    func setupBackgroundView(view: UIView) {
        self.addSubview(view)
        
        view.backgroundColor = .systemBackground
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 컨텐츠를 표현할 뷰를 만듭니다.
    func setupContentView(view: UIView) {
        self.addSubview(view)
        
        view.backgroundColor = .clear
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 뷰의 배경색이 투명하도록 설정합니다.
    func setupViewAlphaValue(view: UIView, alpha: CGFloat) {
        view.alpha = alpha
    }
    
    
    /// 기능버튼이 들어갈 스택뷰를 구성합니다.
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(44)
        }
    }
    
    func functionButtons() {
        /// 현재화면을 캡쳐하고 저장하는 버튼입니다.
        // let saveButton: UIBarButtonItem = makeBarButtonWithTitle(title: "저장", selector: #selector(saveImage), isEnable: false)
    }
    

    
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithTitle(title: String, selector: Selector, isEnable: Bool = true) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isEnabled = isEnable
        
        return button
    }

}
