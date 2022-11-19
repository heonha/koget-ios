//
//  MainViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import SnapKit
import RxSwift
import CoreData
import SwiftUI
import Lottie

/**
 `HomeViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >
 */
class MainWallpaperViewController: UIViewController {
    
    // MARK: Wallpaper Maker 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    lazy var bgMakerButton: UIView = {
        var view = UIView()
        view = makeMenuView(
            title: "배경화면 만들기",
            image: UIImage(named: "rectangle.stack.badge.plus")!,
            action: #selector(presentPHPickerVC)
        )
        return view
    }()
    
    let wallpaperCV: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout() // 레이아웃 종류
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical // 스크롤 방향
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        
        
        return cv
    }()
    
    var myWallpaper: [Wallpaper] = []
    var selectedIndexs: [IndexPath] = []
    
    //MARK: - Models
    
    /// 사진 선택을 했는지 확인하는 Subject
    var isSelected = BehaviorSubject<Bool?>(value: nil)
    let disposeBag = DisposeBag()
    let loadingIndicator: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "LoadingIndicatorGray")
        lottie.translatesAutoresizingMaskIntoConstraints = false
        lottie.contentMode = .scaleAspectFit
        lottie.loopMode = .loop
        lottie.animationSpeed = 1
        lottie.alpha = 0
        return lottie
    }()
    let loadingIndecatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 1
        
        return view
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        let barBtn = ViewModelForCocoa.shared.makeBarButtonWithSystemImage(systemName: "list.bullet.circle", selector: #selector(editButtonTapped), target: self)
        return barBtn
    }()
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "배경화면"
        self.navigationItem.rightBarButtonItem = editButton
        
        configureMainView()
        configureBGMakerButton()
        configurePhotoCV()
        configureLoadingIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyWallpapers()
        hideLoadingIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    private func configureMainView() {
        view.backgroundColor = AppColors.blackDarkGrey

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        if self.isEditing == false {
            self.isEditing = true
            sender.image = UIImage(systemName: "trash.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)

            
        } else {
            self.isEditing = false
            sender.image = UIImage(systemName: "list.bullet.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            if self.selectedIndexs != [] {
                print("이 것이 지워집니다 -> \(selectedIndexs)")
                for index in selectedIndexs {
                    self.myWallpaper.remove(at: index.item)
                }
                deselectAllItems(target: wallpaperCV, animated: true)
                
                self.wallpaperCV.reloadData()

            }
            self.selectedIndexs = []



            }
            

        
    }
    
    func deselectAllItems(target: UICollectionView, animated: Bool) {
        guard let selectedItems = target.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { target.deselectItem(at: indexPath, animated: animated) }
    }
    

    
    // MARK: Configure UI
    
    private func configureBGMakerButton() {
        view.addSubview(bgMakerButton)
        bgMakerButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(view.frame.width - 50)
        }
    }
    
    func loadMyWallpapers() {
        WallpaperCoreData.shared.loadData { [weak self] (wallpapers) in
            self?.myWallpaper = wallpapers
            DispatchQueue.main.async {
                self?.wallpaperCV.reloadData()
            }
        }
    }
    
    private func configureLoadingIndicator() {
        let bounds: CGFloat = 150
        
        view.addSubview(loadingIndecatorView)
        ViewModelForCocoa.shared.addBlurToView(targetView: loadingIndecatorView)
        loadingIndecatorView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.height.width.equalTo(bounds)
        }
        
    }
    
    
    func hideLoadingIndicator() {
        loadingIndicator.alpha = 0
        loadingIndecatorView.alpha = 0
        self.tabBarController?.tabBar.isHidden = false
        loadingIndicator.stop()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.alpha = 1
        loadingIndecatorView.alpha = 0.8
        self.tabBarController?.tabBar.isHidden = true
        loadingIndicator.play()
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
            ViewModelForCocoa.shared.makeLayerShadow(to: view.layer)
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
            ViewModelForCocoa.shared.makeLayerShadow(to: label.layer)
            
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
    
    ///이미지 선택기를 띄웁니다.
    @objc func presentPHPickerVC() {
        let picker = makePHPickerVC()
        picker.delegate = self
        self.present(picker, animated: true)
    
    }
    
    // For UnitTest
    // @objc func presentPHPickerVC() {
    //     let image = UIImage(named: "testImage")!
    //     RxImageViewModel.shared.mainImageSubject.onNext(image)
    //     let photoVC = MakeWallpaperViewController()
    //     photoVC.modalPresentationStyle = .fullScreen
    //     self.present(photoVC, animated: false)
    // }
    //
    
    //MARK: - Methods
    
    /// Picker로 선택한 사진을 가져오고 PhotoViewController를 Push합니다.
    func presentPhotoVC() {
        let photoVC = MakeWallpaperViewController()
        photoVC.modalPresentationStyle = .fullScreen
        self.present(photoVC, animated: false)
        self.showLoadingIndicator()
    }
    

    
}


extension MainWallpaperViewController {
    
    /// PickerViewController를 구성하고 반환하는 메소드입니다. PHPicker 사진 선택기에 대한 Config, Delegate 를 정의합니다.
    func makePHPickerVC() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }
    
}


// MARK: Preview Providers


struct MainWallpaperViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainWallpaperViewController_Representable().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
}

struct MainWallpaperViewController_Representable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        
        // Container VC
        let viewer = MainContainerViewController()
        
        // PhotoVC
        // let viewer = UINavigationController(rootViewController: MainWallpaperViewController())
        
        return viewer
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

