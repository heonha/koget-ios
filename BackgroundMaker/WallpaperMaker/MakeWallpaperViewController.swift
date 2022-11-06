//
//  ViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/05.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift
import RxCocoa
import RulerView
import SwiftUI


enum RulerViewSwitch: String {
    case none
    case edgeBlur
    case backgroundBlur
}

/**
 `PhotoViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >  
 */
class MakeWallpaperViewController: UIViewController {
    
    //MARK: - [Properties] RxSwift
    var disposeBag = DisposeBag()
    var nilDisposeBag = DisposeBag()
    //MARK: End RxSwift Init -
    
    //MARK: - Singleton Architectures
    ///Singleton 객체들
    var imageEditModel = EditImageModel.shared
    var imageViewModel = EditViewModel.shared
    var viewModel = ViewModelForCocoa.shared
    
    //MARK: End Singleton Architectures -
    
    //MARK: - [Properties] ImageViews

    //MARK: 이미지뷰 관련 (이미지뷰, 배경뷰)
    ///`메인 이미지`  편집할 이미지가 들어갈 이미지 뷰
    var mainImageView = UIImageView()
    /// `배경 이미지` 편집할 이미지 뒤에 나타날 배경  이미지
    let bgImageView = UIImageView()
    
    var rulerViewSwitch: RulerViewSwitch = .none
    
    /// `제스쳐` : mainImageView의 중앙 인식을 위한 포인터입니다.
    /// makeDragImageGesture() 메소드에서 사용
    lazy var imageOriginalCenter = CGPoint() // 트레이뷰의 중앙을 인식하는 포인터입니다.
    
    //MARK: - [Properties] Navigation Bar Button
    // 상단 네비게이션 바 버튼
    lazy var shareButton = ViewModelForCocoa.shared.makeBarButtonWithSystemImage(
        systemName: "square.and.arrow.up",
        selector: #selector(shareImageTapped),
        isHidden: false,
        target: self
    )
    lazy var backButton = ViewModelForCocoa.shared.makeBarButtonWithSystemImage(
        systemName: "arrow.backward",
        selector: #selector(backButtonTapped),
        isHidden: false,
        target: self
    )
 
    //MARK: - 하단 트레이뷰 SubViews

    // 트레이뷰 배경 구성
    let trayRootView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.3
        
        return view
    }()
    
    let traySubView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.0
        
        return view
    }()
    
    /// `Tray View` : 기능버튼들이 들어갈 하단 뷰입니다.
    lazy var bottomView = MainEditMenuView(height: 60, target: self)
    
    //MARK: 하단 서브뷰1
    /// 상하단 흐림 RulerView 초기화
    lazy var edgeBlurSliderView = CustomRulerView(title: "엣지블러", delegate: self)
    
    /// [배경화면 편집 뷰] 배경화면 컬러 선택기 초기화
    lazy var colorPickerView = BackgroundPickerView(target: self)
    

    // 저장 버튼
    lazy var saveButton: UIButton = {
        let action = UIAction { _ in self.saveImage() }
        let button = viewModel.makeButtonWithTitle(
            title: "저장", action: action, target: self)
        return button
    }()
    
    // 취소 버튼
    lazy var cancelButton: UIButton = {
        let action = UIAction { _ in self.backButtonTapped() }
        let button = viewModel.makeButtonWithTitle(
            title: "취소", action: action, target: self)
        return button
    }()
    
    // /// `이미지 편집` 버튼
    lazy var edgeBlurButton: MenuButton = {
        let image = UIImage(named: "eraser.line.dashed.fill")!
        let title = "엣지블러"
    
        let button = MenuButton(
            target: self, image: image, title: title,
            action: #selector(edgeBlurTapped), backgroundColor: .clear)
        return button
    }()
    
    /// `백그라운드 편집` 버튼
    lazy var changeBGButton: MenuButton = {
        let image = UIImage(named: "square.2.layers.3d.bottom.filled")!
        let title = "배경레이어"
    
        // 배경편집 버튼 구성
        let button = MenuButton(
            target: self, image: image,
            title: title,
            titleColor: .white,
            action: #selector(bgLayerButtonTapped),
            backgroundColor: .clear
        )
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 네비게이션 바 버튼을 구성합니다.
        self.navigationItem.rightBarButtonItems = [shareButton] // 사진추가, 저장, 자르기 버튼

        self.navigationItem.leftBarButtonItems = [backButton] // 사진추가, 저장, 자르기 버튼
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        // RxSwift
        editingImageRxSubscribe() // 편집할 이미지를 가지고 있을 Observer입니다.
        backgroundImageRxSubscribe()
        setupImageViews()
        
        // SubView : 하단 메뉴바 구성
        addBottomMenuButtons() // 하단 메뉴바 구성
        configureSubviewsToggle()
        setPickedImage() // 앨범에서 선택한 이미지 불러오기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subview 셋업
        self.configureSubmenuBackground() // 트레이 배경뷰
        self.configureTrayView() // 트레이 뷰
        self.switchBlurSubview() // 엣지블러 뷰
        self.makeBGColorPicker() // 배경 컬러 피커뷰
        
        // 이미지 관련 제스쳐
        self.addPinchGesture(selector: #selector(pinchZoomAction)) // Zoom in/out
        self.addPanGesture(selector: #selector(makeDragImageGesture)) // Move
        self.addDoubleTapRecognizer(selector: #selector(doubleTapZoomAction)) // ToubleTab

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 모든 Observable dispose처리
        self.disposeBag = .init()
        
    }
    
    /// 이미지뷰 셋업
    func setupImageViews() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFit
        
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = false
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.edges.equalToSuperview()
        }

        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 불러온 이미지에 따라서 이미지 뷰의 크기를 조절합니다.
    func resizeImageView() {
        /// 이미지뷰 레이아웃
        let screenSize = UIScreen.main.bounds
        let imageSize = mainImageView.image?.size

        let imageHeight = (imageSize!.height * screenSize.width) / imageSize!.width
        let resizeHeight = (screenSize.height - imageHeight) / 2
        
        mainImageView.snp.remakeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(screenSize.width)
            make.height.equalToSuperview().inset(resizeHeight)
        }
    }

    /// 바 버튼의 순서를 재배치합니다..
    func barButtonReplace(buttons: [UIBarButtonItem]) {
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    /// 기능버튼이 들어갈 트레이뷰를 구성합니다.
    func configureTrayView() {

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        /// 트레이 뷰 구성
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(edgeBlurSliderView)
        edgeBlurSliderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(50)
        }
    }
    
    /// 하단 메뉴 ( MainEditMenuView )에 넣을  버튼을 구성합니다.
    func addBottomMenuButtons() {
        /// 버튼들 `스택뷰`에 추가.
        bottomView.centerStackView.addArrangedSubview(edgeBlurButton)
        bottomView.centerStackView.addArrangedSubview(changeBGButton)
        bottomView.rightStackView.addArrangedSubview(saveButton)
        bottomView.leftStackView.addArrangedSubview(cancelButton)
    }
    
    @objc func bgLayerButtonTapped() {
        print("배경레이어버튼 누름")
        
        let duration: CGFloat = 0.2
        
        if self.rulerViewSwitch != .backgroundBlur {
            rulerViewSwitch = .backgroundBlur
            self.switchBlurSubview()
        }

        if colorPickerView.alpha == 0 {
            UIView.animate(withDuration: duration) {
                self.edgeBlurSliderView.alpha = 0
                self.colorPickerView.alpha = 1
                self.traySubView.alpha = 0.4

            }
        } else {
            UIView.animate(withDuration: duration) {
                self.colorPickerView.alpha = 0
                self.traySubView.alpha = 0
            }
        }
    }
    
    /// 엣지블러을 눌렀을 때의 동작입니다.
    @objc func edgeBlurTapped() {
        
        let duration: CGFloat = 0.2
        
        if rulerViewSwitch != .edgeBlur {
            rulerViewSwitch = .edgeBlur
            self.switchBlurSubview()
        }
        
        if edgeBlurSliderView.alpha == 0 {
            UIView.animate(withDuration: duration) {
                self.colorPickerView.alpha = 0
                self.edgeBlurSliderView.alpha = 1
                self.traySubView.alpha = 0.4
            }
        } else {
            UIView.animate(withDuration: duration) {
                self.edgeBlurSliderView.alpha = 0
                self.traySubView.alpha = 0
            }
        }
    }
    
    
    
    private func configureSubviewsToggle() {
        
        edgeBlurSliderView.alpha = 0
        
        
        // 배경 편집기가 떠있는 상태.
        // 1. 배경 편집기 버튼 클릭시
        // - 아무 동작 하지 않는다.
        
        // 2. 블러 버튼 누를 시
        // 인  닫는다
        // 블러  열린다.
        
        // 블러 편집기가 떠있는 상태.
        // 안떠있는 상태.
        
        // 블러, 배경레이어 선택기
        //
        
    }

    
    
    //MARK: - ImageView, PHPicker(ImagePicker) 셋업
    
    /// 선택한 이미지를 가져오고 뷰에 반영합니다.
    func setPickedImage() {
        imageViewModel.editingPhotoSubject
            .subscribe { image in
                guard let image = image else { return }
                
                let bluredImage = image.blurImage(radius: 40)
                
                DispatchQueue.main.async {
                    self.mainImageView.transform = CGAffineTransform(scaleX: 1, y: 1) // 선택한 이미지의 크기를 초기화합니다.
                    self.imageViewModel.backgroundPhotoSubject.onNext(bluredImage)// 선택한 이미지를 블러처리하여 백그라운드에 띄웁니다.
                    self.bgImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 백그라운드 이미지의 크기를 초기화합니다. (결과물 비네팅방지를 위해 1.1배로 설정)
                    EditViewModel.shared.sourcePhotoSubject.onNext(image)
                }
            } onError: { error in
                print("getPickedImage 이미지 가져오기 에러 :\(error.localizedDescription) ")
            } onCompleted: {
                print("selectedPhoto Get Completed")
            } onDisposed: {
                print("selectedPhoto Disposed")
            }.disposed(by: disposeBag)
    }
 
    /// 사진을 디바이스에 저장하는 메소드입니다.
    func saveImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveHandler), nil)
        let newWallpaper = Wallpaper(context: CoreData.shared.persistentContainer.viewContext)
        let imgData = image.pngData()
        newWallpaper.wallpaper = imgData
        newWallpaper.createdDate = Date()
        newWallpaper.id = UUID()
        
        WallpaperCoreData.shared.wallpapers.append(newWallpaper)
        WallpaperCoreData.shared.saveData()
    }
    
    //MARK: - App Configure
    /// 앱의 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
    func openUserAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Selectors
    
    /// 사진 저장 처리결과를 Alert로 Present합니다.
    @objc func imageSaveHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        
        /// 앨범에 사진 저장이 성공 / 실패 했을 때 알럿을 띄웁니다.
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let apply = UIAlertAction(title: "확인", style: .default) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true)
            }
        }
        
        if let error = error {
            /// 사진 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
            let setting = UIAlertAction(title: "설정하기", style: .default) { _ in
                self.openUserAppSettings()
            }
            alert.addAction(setting)
            print("ERROR: \(error)")
            alert.title = "저장 실패"
            alert.message = "사진 저장이 실패했습니다. 아래 설정버튼을 눌러 사진 접근 권한을 확인해주세요."
            return
        } else {
            

            
            alert.addAction(apply)
            alert.title = "저장 성공"
            alert.message = "앨범에서 저장된 사진을 확인하세요."

        }
        present(alert, animated: true)
    }
    

    
    /// 배경화면 저장 시 숨길 뷰들을 리턴합니다.
    func getHideViews() -> [UIView] {
        let hideViews = [self.bottomView, self.edgeBlurSliderView, self.colorPickerView, self.trayRootView, self.traySubView]
        return hideViews
    }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 앨범에 저장하는 메소드입니다.
    @objc func saveImage() {
        if let image = EditImageModel.shared
            .takeScreenViewCapture(
            withoutView: getHideViews(), target: self) {
            saveImageToAlbum(image: image)
        }
    }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 공유합니다.
    @objc func shareImageTapped() {
        if let image = EditImageModel.shared.takeScreenViewCapture(withoutView: getHideViews(), target: self) {
            imageEditModel.shareImageButton(image: image, target: self)
        }
    }
        
    /// 닫기 버튼을 탭했을때의 동작입니다. 사용자에게 편집을 중단 할 것인지 묻는 알림창을 띄웁니다.
    @objc func backButtonTapped() {
        let alert = UIAlertController(title: "이미지의 편집을 중단하고 첫화면으로 이동합니다.", message: "만약 저장하지 않으셨다면 우선 저장해주세요.", preferredStyle: .alert)
        let apply = UIAlertAction(title: "첫 화면 가기", style: .default) { action in
            self.imageViewModel.editingPhotoSubject.onNext(nil)
            self.imageViewModel.backgroundPhotoSubject.onNext(nil)
            self.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(apply)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }

//MARK: - RxSwift View
    /// 편집할 소스 이미지를 담는 비동기 구독입니다.
    func editingImageRxSubscribe() {
        EditViewModel.shared.editingPhoto.subscribe { image in
            print("Rx editingPhoto : 이미지를 가져옵니다.")
            DispatchQueue.main.async {
                self.mainImageView.image = image
                if image != nil {
                    self.resizeImageView()
                }
            }
        } onError: { error in
            print("EditingImage Error : \(error.localizedDescription)")
        } onCompleted: {
            print("EditingImage Completed")
        } onDisposed: {
            print("EditingImage Disposed")
        }.disposed(by: disposeBag)
    }
    
    func backgroundImageRxSubscribe() {
        EditViewModel.shared.backgroundPhoto
            .distinctUntilChanged()
            .subscribe { image in
                print("Rx backgroundPhoto : 이미지가 변경되었습니다.")
                    self.bgImageView.image = image
        } onError: { error in
            print("backgroundPhoto Error : \(error.localizedDescription)")
        } onCompleted: {
            print("backgroundPhoto Completed")
        } onDisposed: {
            print("backgroundPhoto Disposed")
        }.disposed(by: disposeBag)
        
    }
    
}

extension MakeWallpaperViewController {
    
    /// 상하단 블러버튼을 띄웁니다.
    @objc func showUpDownBlurView() {
            self.edgeBlurTapped()
    }
}


// MARK: Preview Providers

struct PhotoViewController_Previews: PreviewProvider {
    static var previews: some View {
        PhotoViewController_Representable().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
}

struct PhotoViewController_Representable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        
        let sampleImage = UIImage(named: "testImage")!
        EditViewModel.shared.editingPhotoSubject.onNext(sampleImage)

        let photoView = MakeWallpaperViewController()

        // MakeWallpaperViewController VC
        let viewer = photoView
        
        return viewer
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

