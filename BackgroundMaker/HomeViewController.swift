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

/**
 `MainViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >
 */
class HomeViewController: UIViewController {
    
    private let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.mainPurple
        return view
    }()
    
    
    private let menuStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentMode = .scaleAspectFill
        sv.distribution = .equalCentering
        sv.axis = .vertical
        sv.spacing = 20
        
        return sv
    }()
    
    
    // MARK: Wallpaper Maker 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    private let bgMakerButton = UIView()
    private let widgetMakerButton = UIView()


    //MARK: - Models
    /// 모델을 불러옵니다.
    private let viewModel = ViewModel.shared
    private let imagePickerModel = ImagePickerModel.shared
    private let imageViewModel = ImageViewModel.shared
    
    let disposeBag = DisposeBag()

    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        view.backgroundColor = AppColors.buttonPutple
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        setMenuStackView()
        
        makeMenuButton(
            mainView: bgMakerButton,
            title: "월페이퍼 만들기",
            image: UIImage(named: "rectangle.stack.badge.plus")!,
            action: #selector(presentPHPickerVC)
        )
        makeMenuButton(
            mainView: widgetMakerButton,
            title: "잠금화면 위젯 만들기",
            image: UIImage(named: "cursorarrow.and.square.on.square.dashed")!,
            action: #selector(presentWidgetVC)
        )

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
    
    /// 위젯 편집기를 띄웁니다.
    @objc func presentWidgetVC() {
        let widgetVC = WidgetViewController()
        self.navigationController?.pushViewController(widgetVC, animated: true)
    }
  
    
    //MARK: - Methods

    /// 메뉴버튼이 들어갈 스택뷰를 구성합니다.
    func setMenuStackView() {
        view.addSubview(menuStackView)
        menuStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(view.frame.width / 1.5)
        }
    }
    
    /// 메뉴버튼을 만들고 menuStackView에 추가합니다.
    private func makeMenuButton(mainView: UIView, title: String, image: UIImage, action: Selector) {
        

        // 컨텐츠 사이즈 지정
        let screenSize = UIScreen.main.bounds
        let spacing: CGFloat = 6
        let buttonSize = CGSize(width: screenSize.width / 1.5, height: screenSize.height / 5 - spacing)
        let padding: CGFloat = 12
        let imageViewHeight: CGFloat = (buttonSize.height) * 4 / 5 - padding
        let labelHeight: CGFloat = buttonSize.height - imageViewHeight - padding
        
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
            // let holderImage = UIImage(named: "rectangle.stack.badge.plus")!
            let holderImage = image.withRenderingMode(.alwaysOriginal)
            let imageView = UIImageView() // 사진 추가하기를 의미하는 이미지
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = holderImage
            // ViewModel.shared.makeLayerShadow(to: imageView.layer)

            return imageView
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = title
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 18, weight: .bold)
            ViewModel.shared.makeLayerShadow(to: label.layer)

            return label
        }()
        
        let button: UIButton = {
          let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: action, for: .touchDown)
            button.backgroundColor = .clear
            return button
        }()
        
        menuStackView.addArrangedSubview(mainView)
        
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
            make.top.equalTo(mainView).inset(padding)
            make.leading.trailing.equalTo(mainView)
            make.height.equalTo(imageViewHeight)
        }
        
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(-spacing)
            make.bottom.equalTo(mainView).inset(padding)
            make.leading.trailing.equalTo(mainView)
            make.height.equalTo(labelHeight)
        }

        button.snp.makeConstraints { make in
            make.edges.equalTo(mainView)
        }
    }
    
    /// Picker로 선택한 사진을 가져오고 PhotoViewController를 Push합니다.
    func pushPhotoVC() {
        let photoVC = PhotoViewController()
        self.navigationController?.pushViewController(photoVC, animated: false)
    }
    

    
    // 네비게이션 바의 흐림효과 (사용보류)
    func addBlurEffect() {
        let bounds = self.navigationController?.navigationBar.bounds
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = bounds ?? CGRect.zero
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.navigationBar.addSubview(visualEffectView)

        // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in the above code to add effects to the custom view.
    }
}
