//
//  MainPhotoViewController+PhotoDelegate.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift


//MARK: - Photo Picker 관련 응답을 받는 PHPickerController Delegate 구성

extension MainWallpaperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            RxImageViewModel.shared.mainImageSubject.onNext(image)
            picker.dismiss(animated: true, completion: nil)
            self.presentPhotoVC()
        } else {
            return
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.hideLoadingIndicator() 
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
        
        guard let wallpaper = item.wallpaper else { return UICollectionViewCell()}
        
        cell.imageView.image = UIImage(data: wallpaper) ?? UIImage(named: "questionmark.circle")!
        
        cell.backgroundColor = .white
        
        
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        wallpaperCV.allowsMultipleSelection = editing
        wallpaperCV.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = wallpaperCV.cellForItem(at: indexPath) as! UserWallpaperCell
            cell.isEditing = editing
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myWallpaper.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if !self.isEditing {
            let item = myWallpaper[indexPath.item]

            let vc = DetailWallpaperViewController(selected: item)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        } else {
            
            let cell = collectionView.cellForItem(at: indexPath) as! UserWallpaperCell
            cell.checkButton.isSelected = true
            print("\(collectionView.indexPathsForSelectedItems)")

            self.selectedIndexs = collectionView.indexPathsForSelectedItems ?? []
            
        }

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                let cell = collectionView.cellForItem(at: indexPath) as! UserWallpaperCell
                cell.checkButton.isSelected = false
                
                self.selectedIndexs = collectionView.indexPathsForSelectedItems ?? []

                return false
            }
        }
        return true
    }
    
    
    // MARK: - FlowLayout Delegate
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
    func userDeletedWallpaper() {
        loadMyWallpapers()
    }
    
}


