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

class MainViewController: UIViewController {
    
    /// 선택한 이미지가 들어갈 이미지뷰
    let sourceImageView = UIImageView()
    
    // MARK: PlaceHolder 초기화
    // "여기를 눌러 사진을 추가하세요" 문구 및 투명 버튼을 통해 Photo Library 띄우는 역할
    /// 라벨과 이미지뷰를 추가할 스택뷰
    let placeholderStackView = UIStackView()
    /// "여기를 눌러 사진을 추가하세요" 문구
    let placeHolderLabel = UILabel()
    let placeHolderImageView = UIImageView() // 사진 추가하기를 의미하는 이미지
    let placeHolderButton = UIButton() // 사진 라이브러리를 띄울 투명버튼
    
    lazy var addImageButton: UIBarButtonItem = self.makeAddImageButton() // 이미지 PHPickerVC를 띄우는 버튼 셋업(Right BarButton)
    lazy var cropButton: UIBarButtonItem = self.makeCropImageButton() // 이미지 자르기 버튼 추가
    
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItems?.append(addImageButton) // 우측 추가 버튼
        self.navigationItem.rightBarButtonItems?.append(cropButton)


        // View 셋업
        setImageView() // 선택한 이미지를 받을 이미지뷰
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.sourceImageView.image != nil {
            self.hidePlaceHolder() // 이미지가 셋업되면 숨김
            self.makePinchGesture(action: #selector(pinchZoomAction)) // 이미지 확대 축소 제스쳐 추가
            self.addDoubleTapRecognizer(selector: #selector(doubleTapZoomAction)) // 더블탭 제스쳐 추가 (더블탭 시 배율 확대, 축소)
            self.enableCropImageButton()
        } else {
            setPlaceHolder()// placeholder 셋업 (이미지가 없을때만 호출)
        }
    }
    
    //MARK: View Load END -

    /// 사진추가 버튼을 구성하고 우측상단 네비게이션 바에 추가합니다. (Right Bar Button)
    func makeAddImageButton() -> UIBarButtonItem {

        let barButtonImage = UIImage(systemName: "plus")?.withTintColor(.systemPink, renderingMode: .automatic)
        let addBarButton = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(presentPHPickerVC))
        return addBarButton
    }
    
    /// 이미지 자르기 버튼을 구성합니다. (Right Bar Button)
    func makeCropImageButton() -> UIBarButtonItem {
        
        let buttonImage = UIImage(systemName: "crop")?.withTintColor(.systemPink, renderingMode: .automatic)
        let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(makeCropMantis))
        button.isEnabled = false
        
        return button
    }
    
    func enableCropImageButton() {
        if self.sourceImageView.image != nil {
            cropButton.isEnabled = true
        } else {
            cropButton.isEnabled = false
        }
    }
    
    /// CropButton의 액션 메소드입니다.
    @objc func takeImageCropping() {
        
        if let image = sourceImageView.image {
            let model = ImageEditModel.shared
            print("이미지 크롭시작")
            let croppedImage = model.cropImage(image: image)
            DispatchQueue.main.async {
                self.sourceImageView.image = croppedImage
            }
        } else {
            print("셋업된 이미지 없음")
        }
        
    }
    
    /// CropButton의 액션 메소드입니다.
    func makeImageButton() {
        if let image = self.sourceImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    /// Process photo saving result
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
    }
    
    //MARK: - Gesture 셋업
    
    //MARK: 사진 확대/축소 제스쳐
    
    /// 두손가락으로 핀치하는 제스쳐를 SuperView에 추가합니다. (
    private func makePinchGesture(action: Selector) {
        var pinch = UIPinchGestureRecognizer()
        
        pinch = UIPinchGestureRecognizer(target: self, action: action)
        self.view.addGestureRecognizer(pinch)
    }
    
    /// 두손가락으로 이미지를 확대, 축소 할수 있는 핀치액션을 구성합니다.
    @objc func pinchZoomAction(_ pinch: UIPinchGestureRecognizer) {
        sourceImageView.transform = sourceImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    //MARK: 더블 탭 제스쳐
    
    /// 화면을 두번 탭하면 이벤트가 발생하는 TapRecognizer를 구성합니다.
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
                self.sourceImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    
    //MARK: Gesture 셋업 END -
   
    // MARK: - PlaceHolder 셋업
    
    /// 사진을 선택하기 전에 표시할 Placeholder Set을 구성하는 메소드입니다.
    /// 이 메소드를 추가하면 Placeholder가 나타납니다. (Config, Layout을 포함합니다)
    private func setPlaceHolder() {

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
    
    /// 사진이 선택되었을 때 PlaceHolder를 숨깁니다.
    private func hidePlaceHolder() {
        placeholderStackView.isHidden = true
        placeHolderButton.isHidden = true
    }
    
    // MARK: PlaceHolder 셋업 END -
    
    //MARK: - ImageView, PHPicker(ImagePicker) 셋업
    
    /// 선택 된 사진을 삽입할 ImageView를 구성하는 메소드입니다.
    private func setImageView() {
        sourceImageView.translatesAutoresizingMaskIntoConstraints = false
        sourceImageView.contentMode = .scaleAspectFit
        view.addSubview(sourceImageView)
        
        sourceImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// PickerViewController를 반환하는 메소드입니다. PHPicker 사진 선택기에 대한 Config, Delegate 를 정의합니다.
    private func makePHPickerVC() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // 가져올 라이브러리 필터
        config.selectionLimit = 1 // 선택할 수 있는 최대 갯수
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }
    
    
    /// PHPickerViewController(사진선택기) 를 Present하는 메소드입니다. (setPHPicker 구성에 따릅니다.)
    @objc func presentPHPickerVC(_ sender: UIButton) {
        let pickerVC = makePHPickerVC()
        present(pickerVC, animated: true)
    }
    //MARK: END -

}

//MARK: - Photo Picker 관련 응답을 받는 PHPickerController Delegate 구성
extension MainViewController: PHPickerViewControllerDelegate {


    /// PHPicker에서 사진 선택했을 때 호출되는 Delegate입니다. PHPicker에서 선택한 아이템을 가져옵니다.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        /// 선택된 아이템이 로드 가능한지 확인하고  에러가 없다면 이미지를 sourceImageView로 전달합니다.
        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        // 에러발생
                        print("사진 LoadObject Error : \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.sourceImageView.image = image as? UIImage
                            self.viewDidAppear(true)
                        }
                    }
                }
            } else {
                print("변환불가")
            }
        }
        dismiss(animated: true) // 이미지를 가져온 후 PHPickerVC를 Dismiss합니다.
    }
}
// canLoadObject : ItemProvider 가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 Bool 값을 반환합니다.
// loadObject : 지정된 클래스의 개체를 항목 공급자에 비동기적으로 로드하여 Progress 개체를 반환합니다.



//MARK: - Crop ViewController 구성 (Mantis Library 사용)
extension MainViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation) {
        
        print("크롭")
        DispatchQueue.main.async {
            self.sourceImageView.image = cropped
        }
        dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        self.dismiss(animated: true)
    }
    
    
    /// 맨티스 라이브러리를 이용한 Crop ViewController를 구성하고 띄우는 메소드
    @objc func makeCropMantis() {
        
        if let image = self.sourceImageView.image { // 불러온 이미지가 있는지 확인합니다.
            /// CropVC로 크롭할 때 사용할 설정을 구성합니다.
            var config = Mantis.Config()
            config.cropShapeType = .circle()
            
            /// Crop을 수행할 뷰 컨트롤러입니다.
            let cropVC = Mantis.cropViewController(image: image, config: config)
            cropVC.delegate = self // CropVC에서 Delegate 를 받습니다.
            present(cropVC, animated: true)
        } else {
            print("크롭할 이미지 없음")
        }
    }
    
    
}


