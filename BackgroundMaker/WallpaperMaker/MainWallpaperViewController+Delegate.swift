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

extension MainWallpaperViewController: PHPickerViewControllerDelegate {
    
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
                            RxImageViewModel.shared.mainImageSubject.onNext(selectedImage)
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


extension MainWallpaperViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func configurePhotoCV() {
        
        
        view.addSubview(wallpaperCV)
        
        wallpaperCV.delegate = self
        wallpaperCV.dataSource = self
        wallpaperCV.register(UserWallpaperCell.self, forCellWithReuseIdentifier: UserWallpaperCell.reuseID)
        
        wallpaperCV.snp.makeConstraints { make in
            make.top.equalTo(bgMakerButton.snp.bottom).inset(-30)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserWallpaperCell.reuseID, for: indexPath) as? UserWallpaperCell else {return UICollectionViewCell() }
        let item = myWallpaper[indexPath.item]
        
        cell.imageView.image = UIImage(data: item.wallpaper!) ?? UIImage(named: "questionmark.circle")!

        
        cell.backgroundColor = .white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myWallpaper.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = myWallpaper[indexPath.item]

        let vc = DetailWallpaperViewController(selected: item)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    
    // MARK: FlowLayout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if myWallpaper.count == 0 {
            return CGSize(width: UIScreen.main.bounds.width / 2, height: 300)
        }
        
        let data = myWallpaper[indexPath.item].wallpaper
        
        let imageSize = ViewModelForCocoa.shared.getImageRatio(image: data, targetWidthMultiply: 0.5)
                
        return imageSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
}

extension MainWallpaperViewController: DetailWallpaperViewControllerDelegate {
    func detailViewWillDisappear() {
        self.loadMyWallpapers()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.wallpaperCV.reloadData()
            }
        }
    }
}



