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
        } else {
            setPlaceHolder()// placeholder 셋업 (이미지가 없을때만 호출)
        }
    }
    
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
    
    // MARK: END -

    

    // 네비게이션 바 버튼 셋업(추가하기 버튼)
    func setNavigationBarButton() {
        let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentPHPickerVC))
        self.navigationItem.rightBarButtonItem = addBarButton // 우측 추가 버튼
    }
    
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
    
    


}

extension MainViewController: PHPickerViewControllerDelegate {


    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // itemProvider = 선택한 자산의 지원되는 표현입니다.
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider {
            // 항목 공급자가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 부울 값을 반환합니다.
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { itemProviderReading, error in
                    if let error = error {
                        // 에러발생
                        print("사진 LoadObject Error : \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.imageView.image = itemProviderReading as? UIImage
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


