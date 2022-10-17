//
//  TrayView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/08.
//

import UIKit
import SnapKit
import RxSwift
import ChameleonFramework

/**
 `BottomMenuView는 PhotoVC의 하단 편집 메뉴를 구성합니다.`
 >  Properties
 */
class BottomMenuView: UIView {
    
    /// 이 뷰를 호출한 뷰컨트롤러입니다.
    var parentVC: PhotoViewController?
    
    /// 뷰의 배경 레이어 입니다. 컨텐츠와 같이 투명해지지 않도록 배경을 분리합니다.
    let backgroundView = UIView()
    
    /// 뷰의 컨텐츠가 들어갈 뷰입니다.
    let contentView = UIView()
    
    /// 기능 버튼이 들어갈 스택뷰입니다.
    lazy var centerStackView = makeStackView()
    lazy var rightStackView = makeStackView()
    lazy var leftStackView = makeStackView()
    
    var viewHeight: CGFloat?
    var rightButtonCount: CGFloat?
    var centerButtonCount: CGFloat?
    var leftButtonCount: CGFloat?
    var backgroundAlphaValue: CGFloat?
    
    /// 현재 뷰를 초기화합니다.
    init(height: CGFloat = 0, rightBtnCount: CGFloat = 0, centerBtnCount: CGFloat = 0, leftBtnCount: CGFloat = 0, backgroundAlpha: CGFloat = 0.2, title: String = "") {
        let screenSize = UIScreen.main.bounds
        
        self.rightButtonCount = rightBtnCount
        self.centerButtonCount = centerBtnCount
        self.leftButtonCount = leftBtnCount
        self.viewHeight = height
        self.backgroundAlphaValue = backgroundAlpha
        
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: height))
        
        setupBackgroundView(view: backgroundView)
        setupViewAlphaValue(view: backgroundView, alpha: backgroundAlphaValue!)
        backgroundView.backgroundColor = .systemBackground
        setupContentView(view: contentView)
        stackViewLayout()
        
        if title != "" {
            // makeTitleView(view: titleView, title: "테스트")
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = title
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = .left
                label.textColor = UIColor.systemBlue
                label.font = .systemFont(ofSize: 15, weight: .bold)
                
                return label
            }()
            
            leftStackView.addArrangedSubview(titleLabel)
            leftStackView.alignment = .top
            leftStackView.alpha = 0.5
            
            leftStackView.snp.remakeConstraints { make in
                make.bottom.centerY.equalTo(contentView)
                make.leading.equalTo(contentView).inset(10)
                make.width.equalTo(80)
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 현재 뷰의 사이즈를 구성합니다.
    override var intrinsicContentSize: CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: viewHeight!)
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
        

        
        if UIDevice.current.isiPhoneWithNotch {
            // 노치 있는 아이폰
            view.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(16)
            }
            
            
        } else {
            // 노치 없는 아이폰
            
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(8)
            }
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
        
        view.backgroundColor = .blue
        
        view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(centerStackView.snp.top)
            make.height.equalTo(30)
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
            make.width.equalTo( centerButtonCount! * buttonWidth )
        }
        
        rightStackView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
            make.centerY.equalTo(contentView)
            
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo( rightButtonCount! * buttonWidth )
        }
        
        leftStackView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
            make.centerY.equalTo(contentView)
            
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo( leftButtonCount! * buttonWidth )
            
        }
    }
}

