//
//  TrayView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit
import SnapKit
import RxSwift

/**
 `BottomMenuView는 PhotoVC의 하단 편집 메뉴를 구성합니다.`
 >  Properties
 */
class MainEditMenuView: UIView {
    
    /// 이 뷰를 호출한 뷰컨트롤러입니다.
    var parentVC: UIViewController!
        
    /// 뷰의 컨텐츠가 들어갈 뷰입니다.
    let contentView = UIView()
    
    /// 기능 버튼이 들어갈 스택뷰입니다.
    lazy var centerStackView = makeStackView()
    lazy var rightStackView = makeStackView()
    lazy var leftStackView = makeStackView()
    
    var rightButtonCount: CGFloat = 1
    var centerButtonCount: CGFloat = 2
    var leftButtonCount: CGFloat = 1
    /// 현재 뷰를 초기화합니다.
    init(height: CGFloat = 0, target: UIViewController) {
        
        self.parentVC = target
        let screenSize = UIScreen.main.bounds
        
        
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height))

        setupContentView(view: contentView)
        stackViewLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Layout Subview
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    //MARK: END Layout Subview -
    
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
            make.top.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    ///
    func makeTitleView(view: UIView, title: String) {
        self.addSubview(view)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        let titleHeight: CGFloat = 30
        view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(centerStackView.snp.top)
            make.height.equalTo(titleHeight)
        }
    }
    
    
    /// 뷰의 배경색이 투명하도록 설정합니다.
    func setupViewAlphaValue(view: UIView, alpha: CGFloat) {
        view.alpha = alpha
    }
    
    /// 기능버튼이 들어갈 스택뷰를 구성합니다.
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.backgroundColor = .clear
        
        return stackView
    }
    
    func stackViewLayout() {
        
        let buttonWidth: CGFloat = 60
        
        centerStackView.snp.makeConstraints { make in
            
            make.top.equalTo(contentView).inset(4)
            make.bottom.equalTo(contentView).inset(4)
            make.centerY.equalTo(contentView)
            
            make.centerX.equalToSuperview()
            make.width.equalTo( centerButtonCount * buttonWidth )
        }
        
        rightStackView.snp.makeConstraints { make in
            make.bottom.top.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
            make.width.equalTo( leftButtonCount * buttonWidth )

        }
        
        leftStackView.snp.makeConstraints { make in
            make.bottom.top.equalTo(contentView)
            make.leading.equalTo(contentView).inset(10)
            make.width.equalTo( leftButtonCount * buttonWidth )
            
        }
    }
}

