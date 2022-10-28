//
//  ColorPalletView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import UIKit
import SnapKit



/// 원형의 Color Pallet 입니다.
class ColorPallet: UIView {
    
    var color: UIImage!
    
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    
    //MARK: - Init
    init(color: UIImage, target: UIViewController) {
        
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: END Init -

    //MARK: - Methods
    private func configureUI() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(color, for: .normal)
        addSubview(button)

        button.addTarget(target, action: #selector(colorBtnTapped), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    @objc func colorBtnTapped(sender: UIButton) {
            ImageViewModel.shared.backgroundPhotoSubject.onNext(self.color)
    }
    
    
}