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
import Lottie


class PhotoViewController: UIViewController {
    
    //MARK: - RxSwift Init
    

    let disposeBag = DisposeBag()
    
    //MARK: End RxSwift Init -
    
    
    var loadingIndicatorView = AnimationView()

    /// 편집할 이미지가 들어갈 이미지 뷰
    var sourceImageView = UIImageView()
    let editImageView = UIImageView()
    var sourceImageSize: CGRect?
    var archiveSourceImage = UIImage()
    
    /// 편집할 이미지 뒤에 나타날 배경 이미지
    let bgImageView = UIImageView()
    
    // MARK: PlaceHolder 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    // let placeholderStackView = UIStackView()
    // /// "여기를 눌러 사진을 추가하세요" 문구
    // let placeHolderLabel = UILabel() // '사진을 추가하세요' 라는 문구의 안내라벨
    // let placeHolderImageView = UIImageView() // 사진 추가하기를 의미하는 이미지
    // let placeHolderButton = UIButton() // 사진 라이브러리를 띄울 투명버튼
    
    let imageModel = ImageEditModel.shared
    let viewModel = ViewModel.shared
    let imageViewModel = ImageViewModel.shared
    lazy var imagePickerModel = ImagePickerModel.shared
    
    /// 기능버튼들이 들어갈 하단 뷰입니다.
    let trayView = BottomMenuView()
    var trayOriginalCenter: CGPoint = CGPoint() // 트레이뷰의 중앙을 인식하는 포인터입니다.
    var trayDownOffset: CGFloat?
    var trayUp: CGPoint?
    var trayDown: CGPoint?
    
    
    /// 기능버튼 (컬렉션뷰)
    var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    
    // MARK: 기능버튼 초기화 (현재는 RightBarButton에만 추가 한 상태)

    /// 현재화면을 캡쳐하고 저장하는 버튼입니다.
    lazy var saveButton: UIBarButtonItem = makeBarButtonWithTitle(title: "저장", selector: #selector(saveImage), isEnable: false)
    
    /// 불러온 이미지를 자르는 버튼입니다.
    lazy var cropButton: UIBarButtonItem = makeBarButtonWithSystemImage(systemName: "square.dashed", selector: #selector(takeImageBlur), isHidden: false, target: self)
    
    /// 공유하기 버튼 입니다.
    lazy var shareButton: UIBarButtonItem = makeBarButtonWithSystemImage(systemName: "square.and.arrow.up", selector: #selector(takeShareImage), isHidden: false, target: self)
    
    /// 초기상태로 다시불러오는 리프레시 버튼 입니다.
    lazy var refreshButton: UIBarButtonItem = makeBarButtonWithSystemImage(systemName: "arrow.counterclockwise", selector: #selector(takeRefreshImage), isHidden: false, target: self)
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        /// 네비게이션 바 버튼을 구성합니다.
        self.navigationItem.rightBarButtonItems = [saveButton, cropButton, shareButton] // 사진추가, 저장, 자르기 버튼
        self.navigationItem.leftBarButtonItems = [refreshButton] // 사진추가, 저장, 자르기 버튼

        /// 뷰 셋업
        setImageViews() // 선택한 사진이 배치 될 이미지뷰를 셋업합니다.
        
        /// 하단 메뉴바 구성
        collectionView.delegate = self
        
        /// RxSwift 구성
        editingImageRxSubscribe()
        
        getPickedImage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 현재 이미지가 셋팅되어있는지에 따라 Place Holder 또는 버튼을 활성화 합니다.
        if self.sourceImageView.image == nil {
            getLoadingIndicator()
        } else {
            self.makePinchGesture(selector: #selector(pinchZoomAction)) // 이미지 확대 축소 제스쳐 추가
            self.makeTrayView() // 트레이 뷰 띄우기
            self.addPanGesture(selector: #selector(makeDragImageGesture)) // 이미지 드래그 제스쳐 추가.
            self.addEdgeGesture(selector: #selector(makeSwipeMenuGesture)) // 메뉴 꺼내기 제스쳐 추가.

            self.addDoubleTapRecognizer(selector: #selector(doubleTapZoomAction)) // 더블탭 제스쳐 추가 (더블탭 시 배율 확대, 축소)
            self.enableBarButtons(buttons: [saveButton, cropButton, shareButton, refreshButton]) // 이미지 로드 전 비활성화 된 바 버튼을 활성화 합니다.
            self.barButtonReplace(buttons: [saveButton, cropButton, shareButton])
            self.hideLoadingIndicator() // 이미지가 셋업되면 숨김

        }
        
    }
    
    func getLoadingIndicator() {
        self.loadingIndicatorView = imageViewModel.makeLottieAnimation(named: "LoadingIndicatorGray", targetView: self.view, targetVC: self, size: CGSize(width: 200, height: 200))
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
        
        trayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.lastBaseline.equalToSuperview()
        }
    }
    
    
    
    //MARK: View Load END -

    
    //MARK: - 뷰 관련 메소드 구성 (네비게이션, 버튼 등)
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithSystemImage(systemName: String, selector: Selector, isHidden: Bool = true, target: UIViewController) -> UIBarButtonItem {
        let buttonImage = UIImage(systemName: systemName)?.withRenderingMode(.automatic)
        let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: selector)
        button.isEnabled = isHidden
        button.tintColor = .label
        
        return button
    }
    
    /// 네비게이션 바에 구성하고 네비게이션 뷰에 추가합니다.
    func makeBarButtonWithTitle(title: String, selector: Selector, isEnable: Bool = true) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        button.isEnabled = isEnable
        button.tintColor = .label
        
        return button
    }
    
    /// 가져온 이미지가 있는 경우 네비게이션 바의 버튼을 활성화 합니다.
    func enableBarButtons(buttons: [UIBarButtonItem]) {
        if self.sourceImageView.image != nil {
            buttons.forEach {
                $0.isEnabled = true
            }
        } else {
            buttons.forEach {
                $0.isEnabled = false
            }
        }
    }
    
    /// CropButton의 액션 메소드입니다.
    func makeImageButton() {
        if let image = self.sourceImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    @objc func takeRefreshImage() {
        self.imageViewModel.editingPhotoSubject.onNext(nil)
        self.loadingIndicatorView.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    
    //MARK: - Gesture 셋업
    
    //MARK: 사진 확대/축소 제스쳐
    
    /// 두손가락으로 핀치하는 제스쳐를 SuperView에 추가합니다.
    private func makePinchGesture(selector: Selector) {
        var pinch = UIPinchGestureRecognizer()
        
        pinch = UIPinchGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(pinch)
    }

    /// 두손가락으로 이미지를 확대, 축소 할수 있는 핀치액션을 구성합니다.
    @objc func pinchZoomAction(_ pinch: UIPinchGestureRecognizer) {
        sourceImageView.transform = sourceImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    //MARK: 더블 탭 제스쳐
    /// 화면을 두번 탭하면 이벤트가 발생하는 TapRecognizer를 구성합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addDoubleTapRecognizer(selector: Selector) {
        let doubleTap = UITapGestureRecognizer(target: self, action: selector)
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }

    /// 더블 탭 액션 ( 기본배율에서 더블탭하면 배율 2배, 그외에는 1배로 초기화, )
    @objc func doubleTapZoomAction(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.sourceImageView.transform == CGAffineTransform(scaleX: 1, y: 1) {
                self.sourceImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            } else {
                self.sourceImageView.center = self.view.center
                self.sourceImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    
    /// PanGesture를 추가합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addPanGesture(selector: Selector) {
        let gesture = UIPanGestureRecognizer(target: self, action: selector)
        self.view.addGestureRecognizer(gesture)
    }
    
    /// 메뉴를 드래그 할수 있는 제스쳐를 만듭니다.
    @objc func makeDragImageGesture(_ sender: UIPanGestureRecognizer) {
        // 지정된 보기의 좌표계에서 팬 제스처를 해석합니다.
        var translation = sender.translation(in: sourceImageView)
        // print("Pan Gesture Translation(CGPoint) : \(translation)")
         
        ///.Began각 제스처 인식의 맨 처음에 한 번 호출됩니다.
        ///.Changed사용자가 "제스처" 과정에 있으므로 계속 호출됩니다.
        ///.Ended제스처의 끝에서 한 번 호출됩니다.
        switch sender.state {
       case .began:
            /// 처음 클릭하기 시작했을 때
           trayOriginalCenter = sourceImageView.center // TrayView의 센터포인트를 저장합니다.
            
        case .changed:
            sourceImageView.center = CGPoint(x: trayOriginalCenter.x + translation.x, y: trayOriginalCenter.y + translation.y)
        default:
            break
        }
        
    }
    
    /// PanGesture를 추가합니다.
    /// - selector : 제스쳐의 action을 구성할 objc 메소드입니다.
    func addEdgeGesture(selector: Selector) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: selector)
        gesture.edges = .bottom
        self.view.addGestureRecognizer(gesture)
    }
    
    //MARK: - Tray

    
    /// [Todo] 스와이프하여 꺼낼수 있는 메뉴를 만듭니다.
    @objc func makeSwipeMenuGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        //        지정된 보기의 좌표계에서 팬 제스처를 해석합니다.
                var translation = sender.translation(in: sourceImageView)
                // print("Pan Gesture Translation(CGPoint) : \(translation)")
                 
                ///.Began각 제스처 인식의 맨 처음에 한 번 호출됩니다.
                ///.Changed사용자가 "제스처" 과정에 있으므로 계속 호출됩니다.
                ///.Ended제스처의 끝에서 한 번 호출됩니다.
                switch sender.state {
               case .began:
                    /// 처음 클릭하기 시작했을 때
                   trayOriginalCenter = sourceImageView.center // TrayView의 센터포인트를 저장합니다.
                    
                case .changed:
                    sourceImageView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
                case .ended:
                    var velocity = sender.velocity(in: view)
                                        
                    if velocity.y > 0 {
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.trayView.center = self.trayDown!
                       })
                    } else {
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.trayView.center = self.trayUp!
                       })
                    }
                default:
                    break
                }
    }

    //MARK: Gesture 셋업 END -
   
    // MARK: - PlaceHolder 셋업
    
    // /**
    //  사진을 선택하기 전에 표시할 Placeholder Set을 구성하는 메소드입니다.
    //  이 메소드를 추가하면 Placeholder가 나타납니다. (Config, Layout을 포함합니다) */
    // private func setPlaceHolder() {
    // 
    //     // PlaceHolder 스택뷰 셋업 (라벨, 이미지뷰 추가됨)
    //     placeholderStackView.translatesAutoresizingMaskIntoConstraints = false
    //     placeholderStackView.axis = .vertical
    //     placeholderStackView.spacing = 10
    //     placeholderStackView.distribution = .fill
    //     placeholderStackView.alignment = .fill
    //     view.addSubview(placeholderStackView)
    //     
    //     // PlaceHolder 사진추가 안내라벨 셋업
    //     placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
    //     placeHolderLabel.text = "이곳을 눌러 사진을 추가하세요."
    //     placeHolderLabel.textAlignment = .center
    //     placeHolderLabel.font = .preferredFont(forTextStyle: .body)
    //     placeHolderLabel.adjustsFontSizeToFitWidth = true
    //     placeholderStackView.addArrangedSubview(placeHolderLabel)
    //     
    //     
    //     // PlaceHolder 이미지뷰 셋업
    //     let placeHolderImage = UIImage(systemName: "rectangle.stack.badge.plus") ?? UIImage()
    //     placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
    //     placeHolderImageView.frame.size = CGSize(width: 100, height: 100)
    //     placeHolderImageView.contentMode = .scaleAspectFit
    //     placeHolderImageView.image = placeHolderImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
    //     placeHolderImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    //     placeholderStackView.addArrangedSubview(placeHolderImageView)
    //     
    //     
    //     // PlaceHolder 스택뷰 레이아웃
    //     placeholderStackView.snp.makeConstraints { make in
    //         make.centerX.centerY.equalToSuperview()
    //         make.width.equalTo(UIScreen.main.bounds.width / 1.5)
    //         make.height.equalTo(UIScreen.main.bounds.height / 7)
    //     }
    //     
    //     // PlaceHolder 사진 선택기 띄울 투명 버튼 셋어뷰 (StackView와 같은 크기)
    //     placeHolderButton.translatesAutoresizingMaskIntoConstraints = false
    //     placeHolderButton.addTarget(self, action: #selector(presentPHPickerVC), for: .touchDown)
    //     view.addSubview(placeHolderButton)
    //     placeHolderButton.snp.makeConstraints { make in
    //         make.edges.equalTo(placeholderStackView)
    //     }
    //     
    // }
    // 
    // /// 사진이 선택되었을 때 PlaceHolder를 숨깁니다.
    // private func hidePlaceHolder() {
    //     placeholderStackView.isHidden = true
    //     placeHolderButton.isHidden = true
    // }
    
    // MARK: PlaceHolder 셋업 END -
    
    //MARK: - ImageView, PHPicker(ImagePicker) 셋업
    
    /// 선택 된 사진을 삽입할 ImageView를 구성하는 메소드입니다.
    private func setImageViews() {
        
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.isUserInteractionEnabled = false
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.edges.equalToSuperview()
        }
        
        sourceImageView.translatesAutoresizingMaskIntoConstraints = false
        sourceImageView.contentMode = .scaleAspectFit
        view.addSubview(sourceImageView)
        
        sourceImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        editImageView.translatesAutoresizingMaskIntoConstraints = false
        editImageView.contentMode = .scaleAspectFit
        // editImageView.isHidden = true
        view.addSubview(editImageView)
        
        editImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    /// PHPickerViewController(사진선택기) 를 Present하는 메소드입니다. (setPHPicker 구성에 따릅니다.)
    // @objc func presentPHPickerVC(_ sender: UIButton) {
    //             
    //     getPickedImage()
    //     
    //     present(imagePickerModel.makePHPickerVC(), animated: true)
    // }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 앨범에 저장하는 메소드입니다.
    @objc func saveImage() {
        if let image = viewModel.takeScreenViewCapture(withoutView: [trayView], target: self) {
            saveImageToAlbum(image: image)
        } else {
            print("저장할 이미지 없음")
        }
    }
    
    /// 사진을 디바이스에 저장하는 메소드입니다.
    func saveImageToAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self,
                                           #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 사진 저장 처리결과를 Alert로 Present합니다.
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
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
    
    /// 앱의 접근권한 확인을 위해 앱의 설정 화면으로 가는 딥링크를 만듭니다.
    func openUserAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    ///사진을 자르고 뷰에 띄웁니다.
    @objc func getCropImage() {
        if let image = self.sourceImageView.image {
            self.sourceImageView.image = self.imageModel.cropImageForScreenSize(image)
        }
    }
    
    /// 병합된 이미지를 뷰에 반영합니다.
    @objc func getMergeImage() {
        if let source = self.sourceImageView.image, let background = self.bgImageView.image {
            
            let mergedImage = self.imageModel.mergeImages(image: source, imageRect: sourceImageView.frame.integral, backgroundImage: background)
            self.sourceImageView.image = mergedImage
        }
    }
    
    /// 현재 뷰를 캡쳐하고 그 이미지를 공유합니다.
    @objc func takeShareImage() {
        if let image = viewModel.takeScreenViewCapture(withoutView: [trayView], target: self) {
            imageModel.shareImageButton(image: image, target: self)
        }
    }
    
    /// 이미지 가장자리에 블러효과를 주는 VC를 띄웁니다.
    @objc func takeImageBlur() {
        if let image = sourceImageView.image {
            
            let vc = EditImageViewController()
            vc.senderVC = self
            
            let imageSize = sourceImageView.image?.size
            vc.imageSize = imageSize
            // vc.editImageView.image = image
            vc.archiveSource = self.archiveSourceImage

            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    //MARK: END -

    
    
    func getPickedImage() {
        
        imagePickerModel.selectedPhotoSubject
            .element(at: 1)
            .take(1)
            .subscribe { image in
            
            guard let image = image else {return}
            
            let blurImage = self.imageModel.makeBlurImage(image: image)
            
            DispatchQueue.main.async {
                self.imageViewModel.editingPhotoSubject.onNext(image)
                self.sourceImageView.transform = CGAffineTransform(scaleX: 1, y: 1) // 선택한 이미지의 크기를 초기화합니다.
                self.archiveSourceImage = image
                self.bgImageView.image = blurImage // 선택한 이미지를 블러처리하여 백그라운드에 띄웁니다.
                self.bgImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 백그라운드 이미지의 크기를 초기화합니다. (결과물 비네팅방지를 위해 1.1배로 설정)

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
}

//MARK: - Photo Picker 관련 응답을 받는 PHPickerController Delegate 구성
// extension PhotoViewController: PHPickerViewControllerDelegate {
//
//     /// PHPicker에서 사진 선택했을 때 호출되는 Delegate입니다. PHPicker에서 선택한 아이템을 가져옵니다.
//     func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//         /// 선택된 아이템이 로드 가능한지 확인하고  에러가 없다면 이미지를 sourceImageView로 전달합니다.
//         if let itemProvider = results.first?.itemProvider {
//             if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                 itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                     guard let self = self else {return}
//                     if let error = error {
//                         // 에러발생
//                         print("사진 LoadObject Error : \(error)")
//                     } else {
//                         let image = image as? UIImage
//
//
//                     }
//                 }
//             } else {
//                 print("변환불가")
//             }
//         }
//         dismiss(animated: true) // 이미지를 가져온 후 PHPickerVC를 Dismiss합니다.
//     }
// }

// canLoadObject : ItemProvider 가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 Bool 값을 반환합니다.
// loadObject : 지정된 클래스의 개체를 항목 공급자에 비동기적으로 로드하여 Progress 개체를 반환합니다.



//MARK: - Crop ViewController 구성 (Mantis Library 사용)
extension PhotoViewController: CropViewControllerDelegate {
    
    /// 맨티스 라이브러리를 이용한 Crop ViewController를 구성하고 띄우는 메소드입니다.
    @objc func presentCropVC() {
        
        if let image = self.sourceImageView.image { // 불러온 이미지가 있는지 확인합니다.
            /// CropVC로 크롭할 때 사용할 설정을 구성합니다.
            var config = Mantis.Config()
            config.cropShapeType = .circle()
            
            /// Crop을 수행할 뷰 컨트롤러입니다.
            let cropVC = Mantis.cropViewController(image: image, config: config)
            cropVC.delegate = self // CropVC에서 Delegate 를 받습니다.
            self.navigationController?.pushViewController(cropVC, animated: true)
        } else {
            print("크롭할 이미지 없음")
        }
    }
    
    /// [Delegate] 이미지가 크롭되었는지 감지하고 알리는 Delegate 메소드입니다.
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation) {
                DispatchQueue.main.async {
            self.sourceImageView.image = cropped
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /// [Delegate] CropViewController에서 취소 버튼을 눌렀을 때의 메소드입니다.
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}




//MARK: - RxSwift View
extension PhotoViewController {
    
    /// 편집할 이미지를 담는 비동기 구독입니다.
    func editingImageRxSubscribe() {
        self.imageViewModel.editingPhoto.subscribe { image in
            print("Rx: 이미지가 변경되었습니다.")
            self.sourceImageView.image = image
        } onError: { error in
            print("SourceImage Error : \(error.localizedDescription)")
        } onCompleted: {
            print("SourceImage Completed")
        } onDisposed: {
            print("SourceImage Disposed")
        }.disposed(by: disposeBag)

    }
    
}


//MARK: - RxSwift Model

class RxViewModel {
    
    let rxImage: Observable<UIImage?>
    
    init(image: UIImage?) {
        self.rxImage = Observable.just(image)
    }
    
}

//MARK: - RxSwift View Model


