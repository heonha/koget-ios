//
//  MantisManager.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit
import Mantis

class MantisManager: UIViewController, CropViewControllerDelegate {
    
    static let shared = MantisManager()
    
    var image: UIImage?
    
    typealias CropShapeItem = (type: Mantis.CropShapeType, title: String)

    let cropShapeItem: [CropShapeItem] = [
        (.rect, "Rect")
    ]
    
    
    func makeCropMantis(image: UIImage) {
        
        var config = Mantis.Config()
        config.cropShapeType = .circle()
        
        let cropVC = Mantis.cropViewController(image: image, config: config)
        present(cropVC, animated: true)
    }
    
    
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation) {

    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        //
    }
    
    
    
    func cropSelector() {
        
    }
    
    
}
