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
import SwiftUI

/**
 `MainViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >
 */
class HomeViewController: UIViewController {
    
    private let mainBackGroundImg = UIImageView()
    
    // MARK: Wallpaper Maker 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    private let bgMakerStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    /// "여기를 눌러 사진을 추가하세요" 문구
    private let bgMakerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "배경화면 편집하기"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 사진 추가 이미지뷰
    private let bgMakerImageView: UIImageView = {
        let holderImage = UIImage(systemName: "rectangle.stack.badge.plus")!
        let imageView = UIImageView() // 사진 추가하기를 의미하는 이미지
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size = CGSize(width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.image = holderImage.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        return imageView
    }()
    
    /// 사진 라이브러리를 띄울 투명버튼
    private lazy var bgMakerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentPHPickerVC), for: .touchDown)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8

        
        return button
    }()
    
    // MARK: Widget Maker 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    private let widgetMakerStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    /// "여기를 눌러 사진을 추가하세요" 문구
    private let widgetMakerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이곳을 눌러 나만의 위젯을 만드세요. \n ( iOS16 이상 )"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 사진 추가 이미지뷰
    private let widgetMakerImageView: UIImageView = {
        let holderImage = UIImage(systemName: "cursorarrow.and.square.on.square.dashed")!
        let imageView = UIImageView() // 사진 추가하기를 의미하는 이미지
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size = CGSize(width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        imageView.image = holderImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
        imageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        return imageView
    }()
    
    /// 사진 라이브러리를 띄울 투명버튼
    private lazy var widgetMakerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentWidgetVC), for: .touchDown)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.alpha = 0.3
        
        button.backgroundColor = .black
        
        return button
    }()
    
    
    //MARK: - Models
    /// 모델을 불러옵니다.
    private let viewModel = ViewModel.shared
    private let imagePickerModel = ImagePickerModel.shared
    private let imageViewModel = ImageViewModel.shared
    
    let disposeBag = DisposeBag()

    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "월메이커"
        
 
        setBackgroundImg()
        configureUI(stackView: bgMakerStackView, label: bgMakerLabel, imageView: bgMakerImageView, button: bgMakerButton)
        configureUIforWidgetMaker(stackView: widgetMakerStackView, label: widgetMakerLabel, imageView: widgetMakerImageView, button: widgetMakerButton)

    }
    
    //MARK: - Selectors

    /// 이미지 선택기를 띄웁니다.
    @objc func presentPHPickerVC() {
        
        imagePickerModel.isSelected
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
  
    
    //MARK: - Methods

    /// 선택한 사진을 가져오고 ViewController를 Push합니다.
    func pushPhotoVC() {
        DispatchQueue.main.async {
            let photoVC = PhotoViewController()
            self.navigationController?.pushViewController(photoVC, animated: false)
        }
    }
    
    /**
     사진을 선택하기 전에 표시할 Placeholder Set을 구성하는 메소드입니다.
     이 메소드를 추가하면 Placeholder가 나타납니다. (Config, Layout을 포함합니다) */
    private func configureUI(stackView: UIStackView, label: UILabel, imageView: UIImageView, button: UIButton) {
        
        // PlaceHolder 스택뷰 셋업 (라벨, 이미지뷰)
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)


        // PlaceHolder 스택뷰 레이아웃
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(-80)
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
            make.height.equalTo(UIScreen.main.bounds.height / 7)
        }
        
        // 사진 선택기 띄울 투명버튼 셋업 (StackView와 같은 크기)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackView)
            make.top.equalTo(stackView).offset(-50)
            make.bottom.equalTo(stackView).offset(50)

        }
        
    }
    
    private func configureUIforWidgetMaker(stackView: UIStackView, label: UILabel, imageView: UIImageView, button: UIButton) {
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(80)
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
            make.height.equalTo(UIScreen.main.bounds.height / 7)
        }
        
        
        
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackView)
            make.top.equalTo(stackView).offset(-50)
            make.bottom.equalTo(stackView).offset(50)

        }
        
    }
    
    private func setBackgroundImg() {
        
        view.addSubview(mainBackGroundImg)
        mainBackGroundImg.translatesAutoresizingMaskIntoConstraints = false
        mainBackGroundImg.image = UIImage(named: "mainBG")
        mainBackGroundImg.contentMode = .scaleAspectFill
        
        guard let image = mainBackGroundImg.image else {return}

        mainBackGroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func presentWidgetVC() {
        
        let widgetView = WidgetView()
        let hosting = UIHostingController(rootView: widgetView)
        hosting.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(hosting, animated: true)
        
    }
}
