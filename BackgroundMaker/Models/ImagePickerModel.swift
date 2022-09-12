//
//  ImagePickerModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/11.
//

import UIKit
import PhotosUI
import RxSwift

class ImagePickerModel {
    
    static let shared = ImagePickerModel()
    
    /// PickerViewController를 구성하고 반환하는 메소드입니다. PHPicker 사진 선택기에 대한 Config, Delegate 를 정의합니다.
    func makePHPickerVC() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // 가져올 라이브러리 필터
        config.selectionLimit = 1 // 선택할 수 있는 최대 갯수
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        return picker
    }
        
    
    /// 소스포토 Observable
    var selectedPhotoSubject = BehaviorSubject<UIImage?>(value: nil)

    /// 사진 선택을 했는지 확인하는 Subject
    var isSelected = BehaviorSubject<Bool?>(value: nil)


}


//MARK: - Photo Picker 관련 응답을 받는 PHPickerController Delegate 구성

extension ImagePickerModel: PHPickerViewControllerDelegate {
    

    /// PHPicker에서 사진 선택했을 때 호출되는 Delegate입니다. PHPicker에서 선택한 아이템을 가져옵니다.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // canLoadObject : ItemProvider 가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 Bool 값을 반환합니다.
        // loadObject : 지정된 클래스의 개체를 항목 공급자에 비동기적으로 로드하여 Progress 개체를 반환합니다.
        /// 선택된 아이템이 로드 가능한지 확인하고  에러가 없다면 이미지를 sourceImageView로 전달합니다.
        if let itemProvider = results.first?.itemProvider {
            self.isSelected.onNext(true) // results가 있다면 바로 선택되었다는 알림을 보냅니다. (이미지 선택 후 UI를 빠르게 업데이트 하기위함)
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else {return}
                    if let error = error {
                        self.isSelected.onNext(false)
                        print("사진 LoadObject Error : \(error)")
                        picker.dismiss(animated: true)

                    } else {
                        let image = image as? UIImage
                        
                        /// 선택된 사진을 업데이트합니다.
                        self.selectedPhotoSubject.onNext(image)
                        }
                    }
                }
            } else {
                print("이미지 선택 오류")
                self.isSelected.onNext(false)
            }
        picker.dismiss(animated: true)
        }
    
}


