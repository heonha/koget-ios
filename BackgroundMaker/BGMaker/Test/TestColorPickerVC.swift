//
//  TestColorPickerVC.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/02.
//

import UIKit
import SnapKit
import ChameleonFramework

class TestColorPickerVC: UIViewController {
    
    
    //MARK: - Properties
    
    let menu = MenuAnimation(title: "하이")

    lazy var button: UIButton = {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        ViewModel.shared.makeLayerShadow(to: button.layer)

        return button
    }()

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeColorSlider()
        menu.alpha = 0
        
    }
    
    //MARK: - Selectors
    
    @objc func buttonTapped() {
        
        
        
        
        menu.snp.remakeConstraints { make in
            make.centerX.equalToSuperview().offset(50)
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(300)
        }

        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5) {
            self.menu.alpha = 1
            self.view.layoutIfNeeded()
            self.menu.alpha = 0
        }

        

        
        
    }
    
    //MARK: - Helpers
    
    private func makeColorSlider() {
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.height.equalTo(50)
        }
        
        let stackView: UIStackView = {
            let sv = UIStackView()
            
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.axis = .horizontal
            sv.spacing = 10
            sv.alignment = .center
            sv.distribution = .fillEqually
            
            return sv
        }()
        
        lazy var circleFlatGreen = ColorPalletView(color: UIColor.flatGreenColorDark(), target: self)
        lazy var circleLime = ColorPalletView(color: UIColor.flatLime(), target: self)
        lazy var circleRed = ColorPalletView(color: UIColor.flatRedColorDark(), target: self)
        lazy var circleBlue = ColorPalletView(color: UIColor.flatBlueColorDark(), target: self)
        lazy var circleSand = ColorPalletView(color: UIColor.flatSand(), target: self)
        
        
        view.backgroundColor = .systemTeal
        
        view.addSubview(stackView)
        
        let colorCircles = [circleFlatGreen, circleLime, circleRed, circleBlue, circleSand]
        let circleSize: CGFloat = 30.0
        
        for circle in colorCircles {
            
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 15
            stackView.addArrangedSubview(circle)
            
            /// Color Slider Layout
            circle.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.width.equalTo(30)
            }
            
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo((colorCircles.count - 1) * 10 + colorCircles.count * 30)
            make.height.equalTo(30)
        }
        
        view.addSubview(menu)
        menu.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(300)
        }
        
    }

    
}
