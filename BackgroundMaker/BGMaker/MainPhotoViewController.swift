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

/**
 `HomeViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >
 */
class MainPhotoViewController: UIViewController {
    
    // MARK: Wallpaper Maker 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    lazy var bgMakerButton: UIView = {
        var view = UIView()
        view = makeMenuView(
            title: "월페이퍼 만들기",
            image: UIImage(named: "rectangle.stack.badge.plus")!,
            action: #selector(presentPHPickerVC)
        )
        return view
    }()
    
    //MARK: - Models
    
    /// 사진 선택을 했는지 확인하는 Subject
    var isSelected = BehaviorSubject<Bool?>(value: nil)
    let disposeBag = DisposeBag()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        configureMainView()
        
        view.addSubview(bgMakerButton)
        bgMakerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(view.frame.width / 1.5)
        }
        
    }
    
    // MARK: Configure UI
    
    private func configureMainView() {
        view.backgroundColor = AppColors.blackDarkGrey
    }
    
    /// 메뉴버튼을 만들고 menuStackView에 추가합니다.
    private func makeMenuView(title: String, image: UIImage, action: Selector) -> UIView {
        
        let mainView = UIView()
        
        // 컨텐츠 사이즈 지정
        let screenSize = UIScreen.main.bounds
        let spacing: CGFloat = 6
        let padding: CGFloat = 12
        
        let buttonSize = CGSize(width: screenSize.width / 1.2, height: 65)
        
        // rootView
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        // 배경 뷰
        let bgView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .black
            view.alpha = 0.3
            view.layer.cornerRadius = 8
            ViewModel.shared.makeLayerShadow(to: view.layer)
            return view
        }()
        
        let imageView: UIImageView = {
            let holderImage = image.withRenderingMode(.alwaysOriginal)
            let imageView = UIImageView() // 사진 추가하기를 의미하는 이미지
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = holderImage
            
            return imageView
        }()
        
        /// 메뉴제목 라벨 초기화
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20, weight: .bold)
            ViewModel.shared.makeLayerShadow(to: label.layer)
            
            return label
        }()
        
        /// 뷰를 감싸는 투명버튼 초기화
        let button: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: action, for: .touchDown)
            button.backgroundColor = .clear
            return button
        }()
        
        view.addSubview(mainView)
        
        mainView.addSubview(bgView)
        mainView.addSubview(imageView)
        mainView.addSubview(label)
        mainView.addSubview(button)
        
        mainView.snp.makeConstraints { make in
            make.width.equalTo(buttonSize.width)
            make.height.equalTo(buttonSize.height)
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
        
        // MARK: Layouts
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainView).inset(padding)
            make.leading.equalTo(mainView).inset(padding)
        }
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(mainView).inset(padding)
            make.leading.equalTo(imageView.snp.trailing).inset(spacing)
            make.trailing.equalTo(mainView).inset(padding)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
        
        return mainView
    }
    
    //MARK: - Selectors
    
    /// 이미지 선택기를 띄웁니다.
    @objc func presentPHPickerVC() {
        let picker = makePHPickerVC()
        self.present(picker, animated: true)
        
    }
    
    
    //MARK: - Methods
    
    /// Picker로 선택한 사진을 가져오고 PhotoViewController를 Push합니다.
    func presentPhotoVC() {
        let photoVC = PhotoViewController()
        photoVC.modalPresentationStyle = .fullScreen
        self.present(photoVC, animated: false)
    }
    
}


extension MainPhotoViewController {
    
    /// PickerViewController를 구성하고 반환하는 메소드입니다. PHPicker 사진 선택기에 대한 Config, Delegate 를 정의합니다.
    func makePHPickerVC() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // 가져올 라이브러리 필터
        config.selectionLimit = 1 // 선택할 수 있는 최대 갯수
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }
    
}





