//
//  ImageEditModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

struct ImageEditModel {
    
    static let shared = ImageEditModel()
    
    /// [개발중] 이미지 자르기
    func cropImage(image: UIImage) -> UIImage {
        
        let sideLenth = min(image.size.width, image.size.height)
        
        
        let sourceSize = image.size
        let xOffset = (sourceSize.width - sideLenth) / 2.0
        let yOffset = (sourceSize.height - sideLenth) / 2.0
        
        /// CropRect는 보관할 이미지의 rect입니다.
        /// 이 경우 중앙
        let cropRect = CGRect(x: xOffset, y: yOffset, width: sideLenth, height: sideLenth).integral
        
        /// 이미지 중앙 자르기
        let sourceCGImage = image.cgImage
        let croppedCGImage = sourceCGImage?.cropping(to: cropRect)
        
        /// 자르기 후 UIImage Type으로 변경
        let croppedImage = UIImage(cgImage: croppedCGImage!, scale: image.imageRendererFormat.scale,
                                   orientation: image.imageOrientation)
        return croppedImage
    }
    
    
}
