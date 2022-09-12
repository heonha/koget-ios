//
//  EditImageViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/09.
//

import UIKit
import SnapKit
import RxSwift

/**
 `EditImageViewController는 이미지뷰 끝부분의 흐림효과를 주는데 사용합니다.`
 >  Properties
 */
class EditImageViewController: UIViewController {
 
    /// 구독을 취소하는 DisposeBag입니다.
    let disposeBag = DisposeBag()
    
    /// 이 뷰컨트롤러를 보낸 뷰컨트롤러를 담습니다.
    var senderVC: PhotoViewController?
    
    /// Model 들의 싱글톤 객체를 구성합니다.
    let imageViewModel = ImageViewModel.shared
    let viewModel = ViewModel.shared
    
    /// 이미지 편집을 수행할 이미지 뷰 관련 프로퍼티입니다.
    var editImageView = UIImageView()
    var imageSize: CGSize?
    var archiveSource = UIImage()
    
    //MARK: - View 로드 구성
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        self.navigationItem.setHidesBackButton(true, animated: false)
        // makeStackView(stackView: menuStackView, subView: [applyButton, cancelButton])

        self.setImageViews(imageView: editImageView)
        setButtons()
        editingImageRxSubscribe(targetImageView: editImageView)
        
    }
    //MARK: END View 로드 구성 -

    //MARK: - RxSwift
    
    //MARK: [Rx] 편집할 이미지 구독
    /// [Rx] 편집할 이미지를 담는 비동기 구독입니다.
    func editingImageRxSubscribe(targetImageView: UIImageView) {
        self.imageViewModel.editingPhoto
            .take(1)
            .subscribe { image in
            print("Rx: 서브뷰가 이미지를 받았습니다.")
            self.imageViewModel.updateImage(photo: image, imageView: self.editImageView) // 이미지 업데이트
        } onError: { error in
            print("SourceImage Error : \(error.localizedDescription)")
        } onCompleted: {
            print("SourceImage Completed")
        } onDisposed: {
            print("SourceImage Disposed")
        }.disposed(by: disposeBag)
    }
    //MARK: RxSwift -

    
    //MARK: - 적용 및 취소 버튼 구성합니다.
    /// 적용, 취소와 같은 기능을 수행할 버튼을 초기화하고 액션을 설정합니다.
    func setButtons() {
    
        /// 블러를 수행할 액션
        let action = UIAction { _ in
            ImageEditModel.shared.makeImageRoundBlur(imageView: self.editImageView)
            let blurImage = ViewModel.shared.takeViewCapture(targetView: self.editImageView)
            self.imageViewModel.editingPhotoSubject.onNext(blurImage)
            self.navigationController?.popViewController(animated: false)
        }
        
        /// 적용된 이미지를 되돌리는 액션
        let cancelAction = UIAction { _ in
            self.imageViewModel.editingPhotoSubject.onNext(self.senderVC?.archiveSourceImage)
            self.navigationController?.popViewController(animated: false)
        }
        
        /// 액션을 수행할 버튼 구성
        let applyButton = viewModel.makeButtonWithTitle(title: "가장자리 흐림 적용", action: action, target: self)
        let cancelButton = viewModel.makeButtonWithTitle(title: "되돌리기", action: cancelAction, target: self)
        
        /// 흐림 적용버튼  레이아웃
        applyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        /// 되돌리기 버튼 레이아웃
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
    
    //MARK: END 적용 및 취소 버튼 구성 -

    //MARK: - 스크린 사이즈에 따른 이미지뷰 높이 구하기

    /**
     `스크린 사이즈에 따라서 높이를 조절합니다.`
     >
     - `공식 :` imageWidth : imageHeight = screenWidth : x
     - `스크린 너비를 받아서 높이 :` x = imageHeight * screenWidth / imageWidth
     */
    func setImageViews(imageView: UIImageView) {
        guard let imageSize = imageSize else {return}
        
        /// 스크린 너비에 따른 이미지뷰 높이 구하기
        let screenSize = view.frame.size
        let imageHeight = (imageSize.height * screenSize.width) / imageSize.width
        let resizeHeight = (screenSize.height - imageHeight) / 2
 
        /// 이미지뷰 기본 셋업
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(editImageView)
        
        /// 이미지뷰 레이아웃
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
    }
}
//MARK: END 이미지 뷰 높이 구하기 -
