//
//  ImageEditModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

class ImageEditModel {
    
    static let shared = ImageEditModel()
    
    /// [개발중] 이미지 자르기
    func cropImage(image: UIImage) -> UIImage {
        
        let sideLenth = min(image.size.width, image.size.height)
        
        ///소스 이미지의 사이즈입니다.
        let sourceSize = image.size
        let xOffset = (sourceSize.width - sideLenth) / 2.0
        let yOffset = (sourceSize.height - sideLenth) / 2.0
        
        let screenSize = UIScreen.main.bounds
        
        /// CropRect는 보관할 이미지의 rect입니다.
        let cropRect = CGRect(x: xOffset, y: yOffset, width: sideLenth, height: sideLenth).integral
        
        /// 이미지 중앙 자르기
        let sourceCGImage = image.cgImage
        let croppedCGImage = sourceCGImage?.cropping(to: cropRect)
        
        /// 자르기 후 UIImage Type으로 변경
        let croppedImage = UIImage(cgImage: croppedCGImage!, scale: image.imageRendererFormat.scale,
                                   orientation: image.imageOrientation)
        return croppedImage
    }
    

    
    /// 여러개의 이미지를 병합합니다. (현재는 2개)
    func mergeImages(image: UIImage, imageRect: CGRect, backgroundImage: UIImage) -> UIImage {
        
        var backImage = backgroundImage
        var frontImage = image

        /// 이미지의 기본 판을 형성합니다.
        let screenSize = UIScreen.main.bounds
        var size = CGSize(width: screenSize.width, height: screenSize.height)
        UIGraphicsBeginImageContext(size)
        
        
        let backAreaSize = screenSize
        backImage.draw(in: backAreaSize)

//        let sourceAreaSize = imageRect
//        print(imageRect)
//        frontImage.draw(in: sourceAreaSize)


        var mergedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return mergedImage
    }
    
    /// 이미지에 블러 효과를 줍니다.
    func makeBlurImage(image: UIImage) -> UIImage {
        return image.blurImage(radius: 40) ?? UIImage()
    }
    
    /// 사진을 가져와서 화면 크기에 맞게 자릅니다.
    func cropImageForScreenSize(_ image: UIImage) -> UIImage {
        let model = ImageEditModel.shared
        let croppedImage = model.cropImage(image: image)
        
        return croppedImage
    }
    
    
    

    
}
public extension UIView {
    @available(iOS 10.0, *)
    
    ///현재 화면에 보이는 View를 캡쳐하고 Image를 반환합니다.
    public func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

        let snapshotImage = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return snapshotImage
    }
}
