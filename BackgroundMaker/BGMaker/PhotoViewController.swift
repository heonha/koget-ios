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
    let disposeBag = DisposeBag()
    
    //MARK: End RxSwift Init -
    
    //MARK: - Singleton Architectures
    ///Singleton 객체들
    lazy var imageEditModel = ImageEditModel.shared
    lazy var imageViewModel = ImageViewModel.shared
    lazy var imagePickerModel = ImagePickerModel.shared
    lazy var viewModel = ViewModel.shared
    
    //MARK: End Singleton Architectures -
    
    //MARK: - [Properties] ImageViews

    //MARK: 이미지뷰 관련 (이미지뷰, 배경뷰)
    ///`메인 이미지`  편집할 이미지가 들어갈 이미지 뷰
    var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// `배경` 편집할 이미지 뒤에 나타날 배경  이미지
    let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    //MARK: - [Properties] Navigation Bar Button
    
    /// `공유버튼` 을 셋업합니다.
    lazy var shareButton: UIBarButtonItem = makeBarButtonWithSystemImage(systemName: "square.and.arrow.up", selector: #selector(shareImageTapped), isHidden: false, target: self)
    
    /// `뒤로가기 버튼` 홈 화면으로 돌아갑니다.
    lazy var backButton: UIBarButtonItem = makeBarButtonWithSystemImage(systemName: "arrow.backward", selector: #selector(backButtonTapped), isHidden: false, target: self)
    
    //MARK: - Tray SubViews
    

    
    //MARK: - [Properties] Tray View
    /// `Tray View` : 기능버튼들이 들어갈 하단 뷰입니다.
    lazy var trayView: BottomMenuView = {
        let bottomView = BottomMenuView(height: 90, rightBtnCount: 1, centerBtnCount: 2, leftBtnCount: 1)
        return bottomView
    }()
    
    //MARK: Tray Subviews
    /// 엣지 블러의 정도를 조절하는 슬라이더 뷰입니다.
    lazy var edgeBlurSliderView: UIView = UIView()
    
    /// 백그라운드
    lazy var bgSubview = BottomMenuView(height: 50, centerBtnCount: 0, leftBtnCount: 0, backgroundAlpha: 0, title: "")
    
    /// 백그라운드 컬러 슬라이더
    lazy var colorPickerView = ColorPickerView(target: self)
    
    
    /// `제스쳐` : Tray View의 중앙 인식을 위한 포인터입니다.
    lazy var imageOriginalCenter: CGPoint = CGPoint() // 트레이뷰의 중앙을 인식하는 포인터입니다.

    
    /// `저장` 버튼
    lazy var saveButton: UIButton = {
        let saveAction = UIAction { _ in
            self.saveImage()
        }
        
        let button = viewModel.makeButtonWithTitle(title: "저장", action: saveAction, target: self)

        return button
    }()
    
    /// `취소` 버튼
    lazy var cancelButton: UIButton = {
        let cancelAction = UIAction { _ in self.backButtonTapped() }
        let button = viewModel.makeButtonWithTitle(title: "취소", action: cancelAction, target: self)

        return button
    }()
    
    /// `블러` 버튼
    lazy var blurButton: MyButton = {
        
        let action = UIAction { action in
            
        }
        
        let button = MyButton(size: .zero, image: UIImage(systemName: "photo")!.withTintColor(.white, renderingMode: .alwaysOriginal), title: "사진편집", action: action, backgroundColor: .clear)
        button.setTitleColor(color: .white)
        
        let blur = UIAction(title: "상하단 흐림효과" ,image: UIImage(systemName: "drop")) { (action) in
            self.hideOtherEditView(selectedView: self.edgeBlurSliderView)
            self.blurAction()
        }
        
        let actions = ViewModel.shared.makeMenuButton(button: button.button, actions: [blur], title: button.label.text!)

        

        return button
    }()
    
    /// `백그라운드 편집` 버튼
    lazy var changeBGButton: MyButton = {
        
        let action = UIAction { action in
            self.hideOtherEditView(selectedView: self.bgSubview)
        }
        
        let button = MyButton(size: .zero, image: UIImage(systemName: "square.3.layers.3d.down.left")!.withTintColor(.white, renderingMode: .alwaysOriginal), title: "배경 편집", action: action, backgroundColor: .clear)
        button.setTitleColor(color: .white)
        
        let blur = UIAction(title: "흐린 이미지 배경", image: UIImage(systemName: "drop"), state: .on) { (action) in
            self.bgBlurAction(sender: button.button)
        }
        
        let color = UIAction(title: "단색 배경", image: UIImage(systemName: "paintpalette")) { (action) in
            self.bgColorAction(sender: button.button)
        }
        
        let actions = ViewModel.shared.makeMenuButton(button: button.button, actions: [blur, color], title: button.label.text!)

        return button
    }()
    

    
    //MARK: - 기타 기능을 위한 프로퍼티 (인디케이터)
    
    //MARK: 인디케이터
    /// 이미지가 로딩되는 동안 표시할 인디케이터뷰 입니다.
    var loadingIndicatorView = AnimationView()
    
    //MARK: END 기타 기능을 위한 프로퍼티 -
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 네비게이션 바 버튼을 구성합니다.
        self.navigationItem.rightBarButtonItems = [shareButton] // 사진추가, 저장, 자르기 버튼
        self.navigationItem.leftBarButtonItems = [backButton] // 사진추가, 저장, 자르기 버튼
        
        /// 뷰 셋업
        setImageViews() // 선택한 사진이 배치 될 이미지뷰를 셋업합니다.
        
        /// 하단 메뉴바 구성
        addBottomMenuButtons()

        /// RxSwift 구성
        editingImageRxSubscribe() // 편집할 이미지를 가지고 있을 Observer입니다.
        backgroundImageRxSubscribe()
        
        
        setPickedImage() // 앨범에서 선택한 이미지 불러오기
        self.trayView.parentVC = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 현재 이미지가 셋팅되어있는지에 따라 Place Holder 또는 버튼을 활성화 합니다.
        if self.mainImageView.image == nil {
            getLoadingIndicator()
        } else {
            // 제스쳐
            self.makePinchGesture(selector: #selector(pinchZoomAction)) // 이미지 확대 축소 제스쳐 추가
            self.addPanGesture(selector: #selector(makeDragImageGesture)) // 이미지 드래그 제스쳐 추가.
            self.addDoubleTapRecognizer(selector: #selector(doubleTapZoomAction)) // 더블탭 제스쳐 추가 (더블탭 시 배율 확대, 축소)
            self.barButtonReplace(buttons: [shareButton])
            self.hideLoadingIndicator() // 이미지가 셋업되면 숨김
            self.resizeImageView() // 이미지 흐림효과를 위한 리사이즈
            
            // Subview 셋업
            self.makeTrayView() // 트레이 뷰 띄우기
            self.makeBlurSubview(view: edgeBlurSliderView) // 엣지 블러 슬라이더뷰 셋업
            self.makeBGEditView(view: bgSubview) // 배경화면 편집 서브뷰 셋업
            self.makeBGColorPicker()
            
        }
        
    }
    
    func getLoadingIndicator() {
        self.loadingIndicatorView = imageViewModel.makeLottieAnimation(named: "LoadingIndicatorGray", targetView: self.view, size: CGSize(width: 200, height: 200), loopMode: .loop)
        self.loadingIndicatorView.play()
    }
    
    func hideLoadingIndicator() {
        self.loadingIndicatorView.isHidden = true
    }
    
    
    
    /// 바 버튼의 순서를 재배치합니다..
    func barButtonReplace(buttons: [UIBarButtonItem]) {
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    /// 기능버튼이 들어갈 트레이뷰를 구성합니다.
    func makeTrayView() {
        
        trayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trayView)
        
        /// 트레이 뷰 구성
        trayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.lastBaseline.equalToSuperview()
        }
    }
    
    /// 하단 메뉴 ( BottomMenuView )에 넣을  버튼을 구성합니다.
    func addBottomMenuButtons() {
        
        /// 버튼들 `스택뷰`에 추가.
        trayView.centerStackView.addArrangedSubview(blurButton)
        trayView.centerStackView.addArrangedSubview(changeBGButton)
        trayView.rightStackView.addArrangedSubview(saveButton)
        trayView.leftStackView.addArrangedSubview(cancelButton)

    }
           
    
    
    
    //MARK: View Load END -
    
    //MARK: - App Configure
    /// 앱의 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
    func openUserAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    //MARK: - ImageView, PHPicker(ImagePicker) 셋업
    

    
    /// 선택한 이미지를 가져오고 뷰에 반영합니다.
    func setPickedImage() {
        
        imagePickerModel.selectedPhotoSubject
            .element(at: 1)
            .take(1)
            .subscribe { image in
                
                guard let image = image else {return}
                
                let bluredImage = image.blurImage(radius: 40)
                
                DispatchQueue.main.async {
                    self.imageViewModel.editingPhotoSubject.onNext(image)
                    self.mainImageView.transform = CGAffineTransform(scaleX: 1, y: 1) // 선택한 이미지의 크기를 초기화합니다.
                    self.imageViewModel.backgroundPhotoSubject.onNext(bluredImage)// 선택한 이미지를 블러처리하여 백그라운드에 띄웁니다.
                    self.bgImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 백그라운드 이미지의 크기를 초기화합니다. (결과물 비네팅방지를 위해 1.1배로 설정)
                    
                    self.imageViewModel.sourcePhotoSubject.onNext(image)

                    self.viewDidAppear(true)
                }
            } onError: { error in
                print("getPickedImage 이미지 가져오기 에러 :\(error.localizedDescription) ")
            } onCompleted: {
                print("selectedPhoto Get Completed")
            } onDisposed: {
                print("selectedPhoto Disposed")
            }.disposed(by: disposeBag)
        
    }
    
    /// 선택 된 사진을 삽입할 ImageView를 구성하는 메소드입니다.
    private func setImageViews() {
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.edges.equalToSuperview()
        }
        

        view.addSubview(mainImageView)
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
 
    /// 현재 뷰를 캡쳐하고 그 이미지를 앨범에 저장하는 메소드입니다.
    @objc func saveImage() {
        if let image = ImageEditModel.shared.takeScreenViewCapture(withoutView: [trayView, edgeBlurSliderView], target: self) {
            saveImageToAlbum(image: image)
        } else {
            print("저장할 이미지 없음")
        }
    }

    /// 사진을 디바이스에 저장하는 메소드입니다.
    func saveImageToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       #selector(imageHandler), nil)
    }
    
    /// 사진 저장 처리결과를 Alert로 Present합니다.
    @objc func imageHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
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
        } else {
            alert.title = "저장 성공"
            alert.message = "앨범에서 저장된 사진을 확인하세요."
        }
        alert.addAction(apply)
        present(alert, animated: true)
    }
    
 
    
    /// 병합된 이미지를 뷰에 반영합니다.
    @objc func getMergeImage() {
        if let source = self.mainImageView.image, let background = self.bgImageView.image {
            
            let mergedImage = self.imageEditModel
                .mergeImages(image: source, imageRect: mainImageView.frame.integral, backgroundImage: background)
            self.mainImageView.image = mergedImage
        }
    }
    
    //MARK: [Todo Refactoring]
    /// 현재 뷰를 캡쳐하고 그 이미지를 공유합니다.
    @objc func shareImageTapped() {
        if let image = ImageEditModel.shared.takeScreenViewCapture(withoutView: [trayView, edgeBlurSliderView], target: self) {
            imageEditModel.shareImageButton(image: image, target: self)
        }
    }
    
    
    //MARK: END -
    
    //MARK: - 뷰 관련 메소드 구성 (네비게이션, 버튼 등)
    
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithSystemImage(systemName: String, selector: Selector, isHidden: Bool = true, target: UIViewController) -> UIBarButtonItem {
        
        // let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: selector)
        let barButton = viewModel.makeBarButtonWithSystemImage(systemName: systemName, selector: selector, target: self)
        
        return barButton
    }
    
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithTitle(title: String, selector: Selector, isEnable: Bool = true) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        barButton.isEnabled = isEnable
        barButton.tintColor = .label
        
        return barButton
    }
        
    /// 닫기 버튼을 탭했을때의 동작입니다. 사용자에게 편집을 중단 할 것인지 묻는 알림창을 띄웁니다.
    @objc func backButtonTapped() {
        let alert = UIAlertController(title: "이미지의 편집을 중단하고 첫화면으로 이동합니다.", message: "만약 저장하지 않으셨다면 우선 저장해주세요.", preferredStyle: .alert)
        let apply = UIAlertAction(title: "첫 화면 가기", style: .default) { action in
            self.imageViewModel.editingPhotoSubject.onNext(nil)
            self.imageViewModel.backgroundPhotoSubject.onNext(nil)

            self.loadingIndicatorView.isHidden = false
            self.navigationController?.popViewController(animated: false)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(apply)
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
}

//MARK: - RxSwift View
extension PhotoViewController {
    
    /// 편집할 소스 이미지를 담는 비동기 구독입니다.
    func editingImageRxSubscribe() {
        self.imageViewModel.editingPhoto.subscribe { image in
            print("Rx EditingImage : 이미지가 변경되었습니다.")
            self.mainImageView.image = image

            
        } onError: { error in
            print("EditingImage Error : \(error.localizedDescription)")
        } onCompleted: {
            print("EditingImage Completed")
        } onDisposed: {
            print("EditingImage Disposed")
        }.disposed(by: disposeBag)
        
    }
    
    func backgroundImageRxSubscribe() {
        imageViewModel.backgroundPhoto
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
    
    // 버튼을 누르면 전환됩니다.
    func changeButton(button: MyButton) {
        // let isSelected = button.isSelected
        // 
        // [changeBGButton, blurButton].forEach { buttons in
        //     buttons.isSelected = false
        // }
        // 
        // button.isSelected = isSelected
        // button.isSelected.toggle()
    }
    
    
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
    
    private func hideOtherEditView(selectedView: UIView) {
        // self.bgSubview.isHidden = true
        edgeBlurSliderView.isHidden = true
        bgSubview.isHidden = true
        colorPickerView.isHidden = true
        
        
        selectedView.isHidden = false
        
    }
    
    @objc func blurAction() {
        
        // sender.showAnimation {
            self.changeButton(button: self.blurButton)
            self.imageBlurAction()
        // }

    }
}
