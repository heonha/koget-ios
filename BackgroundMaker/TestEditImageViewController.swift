//
//  TestEditImageViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/09.
//

import UIKit
import SnapKit

class TestEditImageViewController: UIViewController {
    
    var editImageView = UIImageView()
    var imageSize: CGSize?
    let button = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setImageViews()
        let action = UIAction { _ in
            self.makeImageRoundBlur(imageView: self.editImageView)
            let blurImage = ImageEditModel.shared.takeViewCapture(targetView: self.editImageView)
        }
        makeButtonWithTitle(button: button, title: "액션", action: action, target: self)
    }
    
    func makeButtonWithTitle(button: UIButton, title: String, action: UIAction, target: UIViewController) {
        target.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 8
        button.addAction(action, for: .touchDown)
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    
    private func setImageViews() {

        guard let imageSize = imageSize else {return}
        let screenSize = view.frame.size
        
        // 스크린 사이즈에 따라서 높이
        // imageWidth : imageHeight = screenWidth : x
        // x = imageHeight * screenWidth / imageWidth
        
        let imageHeight = (imageSize.height * screenSize.width) / imageSize.width
        let resizeHeight = (screenSize.height - imageHeight) / 2
 
        editImageView.translatesAutoresizingMaskIntoConstraints = false
        editImageView.contentMode = .scaleAspectFit
        view.addSubview(editImageView)
        
        editImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
        
    }
    
    
    func setBlur() {
        self.makeImageRoundBlur(imageView: self.editImageView)
        let blurImage = ImageEditModel.shared.takeViewCapture(targetView: self.editImageView)
    }
    
    
    /// 이미지 끝부분을 블러처리합니다.
    func makeImageRoundBlur(imageView: UIImageView) {
        
        // 그래디언트 레이어 초기화
        let maskLayer = CAGradientLayer()

        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 10
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: 20, dy: 20), cornerWidth: 0, cornerHeight: 0, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer
        
    }
    
}
