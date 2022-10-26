//
//  ViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/05.
//

import UIKit
import SnapKit
import PhotosUI
import Mantis
import RxSwift
import RxCocoa
import Lottie
import RulerView

/**
 `PhotoViewController는 편집할 이미지를 가져온 후 편집할 수 있는 RootVC입니다.`
 >  
 */
class PhotoViewController: UIViewController {
    
    //MARK: - [Properties] RxSwift
    var disposeBag = DisposeBag()
    var nilDisposeBag = DisposeBag()
    //MARK: End RxSwift Init -
    
    //MARK: - Singleton Architectures
    ///Singleton 객체들
    var imageEditModel = ImageEditModel.shared
    var imageViewModel = ImageViewModel.shared
    var viewModel = ViewModel.shared
    
    //MARK: End Singleton Architectures -
    
    //MARK: - [Properties] ImageViews

    
    //MARK: 로딩 인디케이터 애니메이션
    /// 이미지가 로딩되는 동안 표시할 인디케이터뷰 입니다.
    // var loadingIndicatorView = AnimationView()
    
    
    //MARK: 이미지뷰 관련 (이미지뷰, 배경뷰)
    ///`메인 이미지`  편집할 이미지가 들어갈 이미지 뷰
    var mainImageView = UIImageView()
    /// `배경 이미지` 편집할 이미지 뒤에 나타날 배경  이미지
    let bgImageView = UIImageView()

    /// `제스쳐` : mainImageView의 중앙 인식을 위한 포인터입니다.
    /// makeDragImageGesture() 메소드에서 사용
    lazy var imageOriginalCenter = CGPoint() // 트레이뷰의 중앙을 인식하는 포인터입니다.
    
    //MARK: - [Properties] Navigation Bar Button
    // 상단에 표시될 네비게이션 바 버튼입니다. (뒤로가기, 공유 버튼)
    
    /// `공유버튼 초기화` 공유하기를 띄웁니다.
    lazy var shareButton = UIBarButtonItem()
    /// `뒤로가기 버튼 초기화` 홈 화면으로 돌아갑니다.
    lazy var backButton = UIBarButtonItem()
    
    //MARK: - 하단 트레이뷰 SubViews

    /// `Tray View` : 기능버튼들이 들어갈 하단 뷰입니다.
    lazy var bottomView = BottomMenuView(
        height: 90, rightBtnCount: 1, centerBtnCount: 2, leftBtnCount: 1 )
    
    //MARK: 하단 서브뷰1
    /// 상하단 흐림 RulerView 초기화
    lazy var edgeBlurSliderView = UIView()
    
    /// 배경화면 편집 뷰를 초기화합니다.
    lazy var bgSubview = BottomMenuView(
        height: 50, centerBtnCount: 0, leftBtnCount: 0, backgroundAlpha: 0, title: "")
    
    /// [배경화면 편집 뷰] 배경화면 컬러 선택기 초기화
    lazy var colorPickerView = ColorPickerView(target: self)
    

    /// `저장` 버튼 (우측하단 위치, 이미지 저장기능)
    lazy var saveButton: UIButton = {
        let action = UIAction { _ in self.saveImage() }
        let button = viewModel.makeButtonWithTitle(title: "저장", action: action, target: self)
        return button
    }()
    
    /// `취소` 버튼 (좌측하단 위치, 메인으로 돌아가기)
    lazy var cancelButton: UIButton = {
        let action = UIAction { _ in self.backButtonTapped() }
        let button = viewModel.makeButtonWithTitle(title: "취소", action: action, target: self)
        return button
    }()
    
    /// `이미지 편집` 버튼 (팝업 띄우기 버튼)
    lazy var blurButton: ImageTextButton = {
        let image = UIImage(systemName: "photo")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        let title = "사진편집"
        let action = UIAction { _ in }
        let button = ImageTextButton(
            image: image, title: title, action: action, backgroundColor: .clear)
        button.setTitleColor(color: .white)

        return button
    }()
    
    /// `백그라운드 편집` 버튼
    lazy var changeBGButton: ImageTextButton = {
        
        let buttonAction = UIAction { _ in
            self.hideOtherEditView(selectedView: self.bgSubview)
        }
        
        let image = UIImage(
            systemName: "square.3.layers.3d.down.left")!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        let title = "배경 편집"
        
        // 배경편집 버튼 구성
        let button = ImageTextButton(
            image: image,
            title: title,
            titleColor: .white,
            action: buttonAction,
            backgroundColor: .clear
        )


        return button
    }()
    

    
    //MARK: - 기타 기능을 위한 프로퍼티 (인디케이터)
    

    
    //MARK: END 기타 기능을 위한 프로퍼티 -
    
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
        setupBarButtons()
        // makeLoadingIndicator()
        addBottomMenuButtons() // 하단 메뉴바 구성

        
        setPickedImage() // 앨범에서 선택한 이미지 불러오기
        self.bottomView.parentVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.barButtonReplace(buttons: [shareButton])
        // Subview 셋업
        self.makeTrayView() // 트레이 뷰 띄우기
        self.addImageEditPopupMenu() // 이미지 편집 팝업메뉴 추가
        self.addBackgroundEditPopupMenu() // 배경 편집 팝업메뉴 추가

        self.makeBlurSubview(view: edgeBlurSliderView) // 엣지 블러 슬라이더뷰 셋업
        self.makeBGEditView(view: bgSubview) // 배경화면 편집 서브뷰 셋업
        self.makeBGColorPicker()
        self.makePinchGesture(selector: #selector(pinchZoomAction)) // 이미지 확대 축소 제스쳐 추가
        self.addPanGesture(selector: #selector(makeDragImageGesture)) // 이미지 드래그 제스쳐 추가.
        self.addDoubleTapRecognizer(selector: #selector(doubleTapZoomAction)) // 더블탭 제스쳐 추가 (더블탭 시 배율 확대, 축소)
        // makeLoadingIndicator()

        
        // 현재 이미지가 셋팅되어있는지에 따라 Place Holder 또는 버튼을 활성화 합니다.

    }
    
    /// `상하단 블러` 팝업 메뉴 구성
    func addImageEditPopupMenu() {
        // 팝업 메뉴 구성
        let blur = UIAction(title: "상하단 흐림효과", image: UIImage(systemName: "drop")) { _ in
            self.hideOtherEditView(selectedView: self.edgeBlurSliderView) // 다른 Subview 떠있으면 숨기기
            self.showUpDownBlurView()
        }
        
        /// 위에서 초기화한 액션들 팝업 메뉴에 추가 [Blur]
        ViewModel.shared.makeMenuButton(
            button: blurButton.button, actions: [blur], title: blurButton.label.text!)
    }
    
    func addBackgroundEditPopupMenu() {
        /// [POPUP] 이미지 배경을 흐림으로 변경
        let blurMenu = UIAction(
            title: "흐린 이미지 배경",
            image: UIImage(systemName: "drop"),
            state: .on
        ) { _ in
            self.bgBlurAction(sender: self.changeBGButton.button)
        }
        
        /// [POPUP ] 이미지 배경을 단색으로 변경
        let colorPalletMenu = UIAction(title: "단색 배경", image: UIImage(systemName: "paintpalette")) { (action) in
            self.bgColorAction(sender: self.changeBGButton.button)
        }
        
        // button에 팝업 메뉴 추가
        ViewModel.shared.makeMenuButton(
            button: changeBGButton.button,
            actions: [blurMenu, colorPalletMenu],
            title: changeBGButton.label.text!
        )
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

    /// 상단 네비게이션 바버튼 셋업
    func setupBarButtons() {
        shareButton = ViewModel.shared.makeBarButtonWithSystemImage(
            systemName: "square.and.arrow.up",
            selector: #selector(shareImageTapped),
            isHidden: false,
            target: self
        )
        
        backButton = ViewModel.shared.makeBarButtonWithSystemImage(
            systemName: "arrow.backward",
            selector: #selector(backButtonTapped),
            isHidden: false,
            target: self
        )
    }
    
    /// 바 버튼의 순서를 재배치합니다..
    func barButtonReplace(buttons: [UIBarButtonItem]) {
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    /// 기능버튼이 들어갈 트레이뷰를 구성합니다.
    func makeTrayView() {

        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        /// 트레이 뷰 구성
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.lastBaseline.equalToSuperview()
        }
    }
    
    /// 하단 메뉴 ( BottomMenuView )에 넣을  버튼을 구성합니다.
    func addBottomMenuButtons() {
        /// 버튼들 `스택뷰`에 추가.
        bottomView.centerStackView.addArrangedSubview(blurButton)
        bottomView.centerStackView.addArrangedSubview(changeBGButton)
        bottomView.rightStackView.addArrangedSubview(saveButton)
        bottomView.leftStackView.addArrangedSubview(cancelButton)
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
                    ImageViewModel.shared.sourcePhotoSubject.onNext(image)
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
        let apply = UIAlertAction(title: "확인", style: .default, handler: nil)
        
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
            alert.title = "저장 성공"
            alert.message = "앨범에서 저장된 사진을 확인하세요."
        }
        alert.addAction(apply)
        present(alert, animated: true)
    }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 앨범에 저장하는 메소드입니다.
    @objc func saveImage() {
        if let image = ImageEditModel.shared.takeScreenViewCapture(
            withoutView: [bottomView, edgeBlurSliderView], target: self)
        {
            saveImageToAlbum(image: image)
        }
    }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 공유합니다.
    @objc func shareImageTapped() {
        if let image = ImageEditModel.shared.takeScreenViewCapture(withoutView: [bottomView, edgeBlurSliderView], target: self) {
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
        ImageViewModel.shared.editingPhoto.subscribe { image in
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
        ImageViewModel.shared.backgroundPhoto
            .subscribe { image in
                print("Rx backgroundPhoto : 이미지가 변경되었습니다.")
                UIView.animate(withDuration: 0.1) {
                    self.bgImageView.alpha = 0.8
                    self.bgImageView.image = image
                    self.bgImageView.alpha = 1
                }
        } onError: { error in
            print("backgroundPhoto Error : \(error.localizedDescription)")
        } onCompleted: {
            print("backgroundPhoto Completed")
        } onDisposed: {
            print("backgroundPhoto Disposed")
        }.disposed(by: disposeBag)
        
    }
    
}

extension PhotoViewController {
    
    @objc func changeBGButtonAction(sender: UIButton) {
 
        sender.showAnimation {
            if self.bgSubview.isHidden == false {
                self.bgSubview.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.bgSubview.alpha = 1
                }
            } else {
                self.colorPickerView.isHidden = true
                self.bgSubview.alpha = 1
                UIView.animate(withDuration: 0.2) {
                    self.bgSubview.alpha = 0
                }
            }
        }

    }
    
    /// 현재 클릭한 뷰 외의 다른 버튼들을 숨깁니다.
    private func hideOtherEditView(selectedView: UIView) {
        edgeBlurSliderView.isHidden = true
        bgSubview.isHidden = true
        colorPickerView.isHidden = true
        selectedView.isHidden = false
    }
    
    /// 상하단 블러버튼을 띄웁니다.
    @objc func showUpDownBlurView() {
            self.imageBlurAction()
    }
}
