//
//  MainPhotoViewController+PhotoDelegate.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import PhotosUI


//MARK: - Photo Picker 관련 응답을 받는 PHPickerController Delegate 구성

extension MainPhotoViewController: PHPickerViewControllerDelegate {
    
    /// PHPicker에서 사진 선택했을 때 호출되는 Delegate입니다. PHPicker에서 선택한 아이템을 가져옵니다.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // canLoadObject : ItemProvider 가 지정된 클래스의 개체를 로드할 수 있는지 여부를 나타내는 Bool 값을 반환합니다.
        // loadObject : 지정된 클래스의 개체를 항목 공급자에 비동기적으로 로드하여 Progress 개체를 반환합니다.
        /// 선택된 아이템이 로드 가능한지 확인하고  에러가 없다면 이미지를 sourceImageView로 전달합니다.
        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let self = self else {return}
                    if let error = error {
                        print("사진 LoadObject Error : \(error)")
                        picker.dismiss(animated: true)
                    } else {
                        let selectedImage = image as! UIImage
                        /// 선택된 사진을 업데이트합니다.
                        DispatchQueue.main.async {
                            ImageViewModel.shared.editingPhotoSubject.onNext(selectedImage)
                            self.presentPhotoVC()
                        }
                    }
                }
            }
        } else {
            print("이미지 선택 오류")
        }
        
        picker.dismiss(animated: true)
        
    }
    
}
