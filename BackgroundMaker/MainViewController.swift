//
//  MainViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import SnapKit
import RxSwift
import PhotosUI
import Lottie


class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    // MARK: PlaceHolder 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    let placeholderStackView = UIStackView()
    /// "여기를 눌러 사진을 추가하세요" 문구
    let placeHolderLabel = UILabel() // '사진을 추가하세요' 라는 문구의 안내라벨
    let placeHolderImageView = UIImageView() // 사진 추가하기를 의미하는 이미지
    let placeHolderButton = UIButton() // 사진 라이브러리를 띄울 투명버튼
    
    let viewModel = ViewModel.shared
    let imagePickerModel = ImagePickerModel.shared
    let imageViewModel = ImageViewModel.shared
    

    ///사진을 추가하는 기능을 하는 버튼입니다.
    lazy var addButton: UIBarButtonItem = viewModel.makeBarButtonWithSystemImage(systemName: "plus.square.fill.on.square.fill", selector: #selector(presentPHPickerVC), isHidden: true, target: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [addButton] // 사진추가, 저장, 자르기 버튼
        setPlaceHolder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    
    @objc func presentPHPickerVC(_ sender: UIButton) {
        
        imagePickerModel.isSuccess
            .element(at: 1)
            .take(1)
            .subscribe { bool in
                
                if bool == true {
                    DispatchQueue.main.async {
                        self.pushPhotoVC()
                    }
                } else {
                    return
                }
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }.disposed(by: disposeBag)
        
        let picker = imagePickerModel.makePHPickerVC()
        
        self.present(picker, animated: true)
    }
  
    
    func pushPhotoVC() {
        print("호출됨")
        DispatchQueue.main.async {
            let photoVC = PhotoViewController()
            self.navigationController?.pushViewController(photoVC, animated: false)
        }
    }
    
    
    /**
     사진을 선택하기 전에 표시할 Placeholder Set을 구성하는 메소드입니다.
     이 메소드를 추가하면 Placeholder가 나타납니다. (Config, Layout을 포함합니다) */
    private func setPlaceHolder() {
        
        // print("스택뷰")
        // PlaceHolder 스택뷰 셋업 (라벨, 이미지뷰 추가됨)
        placeholderStackView.translatesAutoresizingMaskIntoConstraints = false
        placeholderStackView.axis = .vertical
        placeholderStackView.spacing = 10
        placeholderStackView.distribution = .fill
        placeholderStackView.alignment = .fill
        view.addSubview(placeholderStackView)
        
        // PlaceHolder 사진추가 안내라벨 셋업
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.text = "이곳을 눌러 사진을 추가하세요."
        placeHolderLabel.textAlignment = .center
        placeHolderLabel.font = .preferredFont(forTextStyle: .body)
        placeHolderLabel.adjustsFontSizeToFitWidth = true
        placeholderStackView.addArrangedSubview(placeHolderLabel)
        
        
        // PlaceHolder 이미지뷰 셋업
        let placeHolderImage = UIImage(systemName: "rectangle.stack.badge.plus") ?? UIImage()
        placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeHolderImageView.frame.size = CGSize(width: 100, height: 100)
        placeHolderImageView.contentMode = .scaleAspectFit
        placeHolderImageView.image = placeHolderImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
        placeHolderImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        placeholderStackView.addArrangedSubview(placeHolderImageView)
        
        
        // PlaceHolder 스택뷰 레이아웃
        placeholderStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
            make.height.equalTo(UIScreen.main.bounds.height / 7)
        }
        
        // PlaceHolder 사진 선택기 띄울 투명 버튼 셋어뷰 (StackView와 같은 크기)
        placeHolderButton.translatesAutoresizingMaskIntoConstraints = false
        placeHolderButton.addTarget(self, action: #selector(presentPHPickerVC), for: .touchDown)
        view.addSubview(placeHolderButton)
        placeHolderButton.snp.makeConstraints { make in
            make.edges.equalTo(placeholderStackView)
        }
        
    }
}
