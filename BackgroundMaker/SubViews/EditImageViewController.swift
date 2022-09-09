//
//  EditImageViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/09.
//

import UIKit
import SnapKit

protocol EditImageViewControllerDelegate {
    func editImageSet(image: UIImage)
}


class EditImageViewController: UIViewController {
    
    var editImageView = UIImageView()
    var imageSize: CGSize?
    let applyButton = UIButton()
    let cancelButton = UIButton()

    var archiveSource = UIImage()
    
    var delegate: EditImageViewControllerDelegate?
    let menuStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.navigationItem.setHidesBackButton(true, animated: false)
        makeStackView(stackView: menuStackView, subView: [applyButton, cancelButton])

        setImageViews()
        let action = UIAction { _ in
            ImageEditModel.shared.makeImageRoundBlur(imageView: self.editImageView)
            let blurImage = ViewModel.shared.takeViewCapture(targetView: self.editImageView)
            self.delegate?.editImageSet(image: blurImage)
            self.navigationController?.popViewController(animated: false)
        }
        
        let cancelAction = UIAction { _ in
            self.delegate?.editImageSet(image: self.archiveSource)
            self.navigationController?.popViewController(animated: false)
        }
        makeButtonWithTitle(button: applyButton, title: "가장자리 흐림 적용", action: action, target: self)
        applyButton.backgroundColor = .systemBlue
        makeButtonWithTitle(button: cancelButton, title: "되돌리기", action: cancelAction, target: self)
        cancelButton.backgroundColor = .systemGray
        
    }
    
    func makeButtonWithTitle(button: UIButton, title: String, action: UIAction, target: UIViewController) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        // button.layer.cornerRadius = 8
        button.addAction(action, for: .touchDown)
    }
    
    /// 적용, 취소버튼을 넣을 스택뷰를 구성합니다.
    func makeStackView(stackView: UIStackView, subView: [UIView]) {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        subView.forEach { views in
            stackView.addArrangedSubview(views)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
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
    

    
    
}
