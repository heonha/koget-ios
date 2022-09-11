//
//  EditImageViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/09.
//

import UIKit
import SnapKit
import RxSwift

class EditImageViewController: UIViewController {
 
    let disposeBag = DisposeBag()
    var senderVC: PhotoViewController?
    
    let imageViewModel = ImageViewModel.shared
    
    /// 이미지 편집을 수행할 이미지 뷰입니다.
    var editImageView = UIImageView()
    var imageSize: CGSize?
    let applyButton = UIButton()
    let cancelButton = UIButton()

    var archiveSource = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.navigationItem.setHidesBackButton(true, animated: false)
        // makeStackView(stackView: menuStackView, subView: [applyButton, cancelButton])

        setImageViews()
        setButtons()
        editingImageRxSubscribe(targetImageView: editImageView)
        
    }
    
    /// [Rx] 편집할 이미지를 담는 비동기 구독입니다.
    func editingImageRxSubscribe(targetImageView: UIImageView) {
        self.imageViewModel.editingPhoto.subscribe { [weak self] image in
            print("Rx: 서브뷰가 이미지를 받았습니다.")
            guard let self = self else {return}
            self.imageViewModel.updateImage(photo: image, imageView: self.editImageView) // 이미지 업데이트
        } onError: { error in
            print("SourceImage Error : \(error.localizedDescription)")
        } onCompleted: {
            print("SourceImage Completed")
        } onDisposed: {
            print("SourceImage Disposed")
        }.disposed(by: disposeBag)
    }
    
    
    func makeButtonWithTitle(button: UIButton, title: String, action: UIAction, target: UIViewController) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        // button.layer.cornerRadius = 8
        button.addAction(action, for: .touchDown)
    }
    
    /// 적용, 취소와 같은 기능을 수행할 버튼을 초기화하고 액션을 설정합니다.
    func setButtons() {
        let action = UIAction { _ in
            ImageEditModel.shared.makeImageRoundBlur(imageView: self.editImageView)
            let blurImage = ViewModel.shared.takeViewCapture(targetView: self.editImageView)
            self.imageViewModel.editingPhotoSubject.onNext(blurImage)
            self.navigationController?.popViewController(animated: false)
        }
        
        let cancelAction = UIAction { _ in
            self.imageViewModel.editingPhotoSubject.onNext(self.senderVC?.archiveSourceImage)
            self.navigationController?.popViewController(animated: false)
        }
        makeButtonWithTitle(button: applyButton, title: "가장자리 흐림 적용", action: action, target: self)
        makeButtonWithTitle(button: cancelButton, title: "되돌리기", action: cancelAction, target: self)
        
        applyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(44)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(44)
            make.leading.equalToSuperview().inset(30)
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
