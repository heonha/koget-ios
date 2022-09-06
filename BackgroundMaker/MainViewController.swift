//
//  ViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/05.
//

import UIKit
import SnapKit
import RxSwift
import PhotosUI

class MainViewController: UIViewController {
    
    // 선택한 이미지
    let imageView = UIImageView()
    
    // 라이브러리 이미지 가져오기
    let selectedImage = UIImage()

    let placeholderStackView = UIStackView()
    
    // PlaceHolder 초기화
    let placeHolderLabel = UILabel()
    let placeHolderButton = UIButton()
    let placeHolderImageView = UIImageView()
    
    
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        // 네비게이션 아이템 셋업
        setNavigationBarButton() // 우측상단 추가버튼 셋업
        
        // View 셋업
        setImageView() // 선택한 이미지를 받을 이미지뷰
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.imageView.image != nil {
            self.hidePlaceHolder() // 이미지가 셋업되면 숨김
            self.makePinchGesture() // 이미지 확대 축소 제스쳐 추가
            self.addDoubleTapRecognizer() // 더블탭 제스쳐 추가 (더블탭 시 배율 확대, 축소)

        } else {
            setPlaceHolder()// placeholder 셋업 (이미지가 없을때만 호출)
        }
    }
    
    //MARK: View Load END -

    // 네비게이션 바 버튼 셋업(추가하기 버튼)
    func setNavigationBarButton() {
        let barButtonImage = UIImage(systemName: "plus")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        let addBarButton = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(presentPHPickerVC))
        self.navigationItem.rightBarButtonItem = addBarButton // 우측 추가 버튼
    }
    
    //MARK: - Gesture 셋업
    
    //MARK: 사진 확대/축소 제스쳐
    private func makePinchGesture() {
        var pinch = UIPinchGestureRecognizer()
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        self.view.addGestureRecognizer(pinch)
    }
    
    @objc func pinchAction(_ pinch: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }
    
    //MARK: 더블 탭 제스쳐
    func addDoubleTapRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
    }

    /// 더블 탭 액션 ( 기본배율에서 더블탭하면 배율 2배, 그외에는 1배로 초기화, )
    @objc func doubleTapAction(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.imageView.transform == CGAffineTransform(scaleX: 1, y: 1) {
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            } else {
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
    }
    
    
    //MARK: Gesture 셋업 END -
    // MARK: - PlaceHolder 셋업
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
    
    // 사진이 선택되었을 때 PlaceHolder를 숨깁니다.
    private func hidePlaceHolder() {
        placeholderStackView.isHidden = true
        placeHolderButton.isHidden = true
    }
    
    // MARK: PlaceHolder 셋업 END -
    
    //MARK: - ImageView, PHPicker(ImagePicker) 셋업
    // 선택 된 사진이 들어갈 ImageView 셋업
    private func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // PHPicker 사진 선택기 셋업
    private func setPHPicker() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // 가져올 라이브러리 필터
        config.selectionLimit = 1 // 선택할 수 있는 최대 갯수
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }
    
    
    // PHPickerVC 띄우기
    @objc func presentPHPickerVC(_ sender: UIButton) {
        let pickerVC = setPHPicker()
        present(pickerVC, animated: true)
    }
    //MARK: END -

}

//MARK: - PHPicker Delegate
extension MainViewController: PHPickerViewControllerDelegate {


    // PHPicker에서 사진 선택했을 때 호출되는 Delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // itemProvider = 선택한 자산의 지원되는 표현입니다.
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        // 에러발생
                        print("사진 LoadObject Error : \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.imageView.image = image as? UIImage
                            self.viewDidAppear(true)
                        }
                    }
                }
            } else {
                print("변환불가")
            }
        }
        dismiss(animated: true)
    }
}
// canLoadObject : ItemProvider 가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 Bool 값을 반환합니다.
// loadObject : 지정된 클래스의 개체를 항목 공급자에 비동기적으로 로드하여 Progress 개체를 반환합니다.


