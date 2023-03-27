//
//  PhotoPicker.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    weak var makeModel: MakeWidgetViewModel?
    weak var detailModel: DetailWidgetViewModel?
    var viewModel: any VMPhotoEditProtocol

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoPicker>) {

    }
    
    func makeCoordinator() -> Coodinator {
        Coodinator(photoPicker: self)
    }
    
    final class Coodinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

                photoPicker.viewModel.image = image
                // if photoPicker.makeModel != nil {
                //     photoPicker.makeModel?.image = image
                // } else {
                //     photoPicker.detailModel?.image = image
                // }
            } else {
                return
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
