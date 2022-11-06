//
//  ColorPalletView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import UIKit
import SnapKit


enum ColorPalletType {
    case normal
    case showRuler
}

/// 원형의 Color Pallet 입니다.
class ColorPallet: UIView {
    
    var color: UIImage!
    var type: ColorPalletType!
    var target: PhotoViewController!
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    
    //MARK: - Init
    init(color: UIImage, target: PhotoViewController, type: ColorPalletType = .normal) {
        
        self.color = color
        self.type = type
        self.target = target

        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func configureUI() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(color, for: .normal)
        addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        if self.type == .normal {
            button.addTarget(target, action: #selector(colorBtnTapped), for: .touchDown)
        }
        
        if self.type == .showRuler {
            button.addTarget(target, action: #selector(blurBtnTapped), for: .touchDown)
        }
        
    }
    
    @objc func colorBtnTapped(_ sender: UIButton) {
            ImageViewModel.shared.backgroundPhotoSubject.onNext(self.color)
    }
    
    @objc func blurBtnTapped(_ sender: UIButton) {
        
        let image: UIImage = {
            var mainImg: UIImage?
            ImageViewModel.shared.editingPhotoSubject.subscribe { image in
                mainImg = image
            }.dispose()
            
            return mainImg ?? UIImage(named: "questionmark.circle")!
        }()
        
        ImageViewModel.shared.backgroundPhotoSubject.onNext(image)
        target.switchBlurSubview()
        
        let duration: CGFloat = 0.2
        
        if target.edgeBlurSliderView.alpha == 0 {
            UIView.animate(withDuration: duration) {
                self.target.colorPickerView.alpha = 0
                self.target.edgeBlurSliderView.alpha = 1
                self.target.traySubView.alpha = 0.4
            }
        } else {
            UIView.animate(withDuration: duration) {
                self.target.edgeBlurSliderView.alpha = 0
                self.target.traySubView.alpha = 0
            }
        }
    }
}
