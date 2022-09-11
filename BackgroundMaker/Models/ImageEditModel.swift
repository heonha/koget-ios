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
        
        let backImage = backgroundImage
        let frontImage = image

        /// 이미지의 기본 판을 형성합니다.
        let screenSize = UIScreen.main.bounds
        let size = CGSize(width: screenSize.width, height: screenSize.height)
        UIGraphicsBeginImageContext(size)
        
        
        let backAreaSize = screenSize
        backImage.draw(in: backAreaSize)

        let sourceAreaSize = imageRect
        print(imageRect)
        frontImage.draw(in: sourceAreaSize)


        let mergedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return mergedImage
    }
    
    /// 이미지에 블러 효과를 줍니다.
    func makeBlurImage(image: UIImage) -> UIImage {
        return image.blurImage(radius: 40) ?? UIImage()
    }
    
    /// 사진을 가져와서 화면 크기에 맞게 자릅니다.
    func cropImageForScreenSize(_ image: UIImage) -> UIImage {
        let croppedImage = cropImage(image: image)
        return croppedImage
    }
    
    ///이미지 공유를 위한 ActivityViewController를 구성하고 띄웁니다.
    func shareImageButton(image: UIImage, target: UIViewController) {
        
        /// 액티비티 뷰 컨트롤러 설정
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = target.view // so that iPads won't crash
        /// 목록에서 일부 활동 유형 제외하기
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
        
        // activityViewController 띄우기
        target.present(activityViewController, animated: true, completion: nil)
        
    }
    
    /// 이미지 끝부분을 블러처리합니다.
    func makeImageRoundBlur(imageView: UIImageView) {
        let maskLayer = CAGradientLayer()

        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 10
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: 20, dy: 20), cornerWidth: 0, cornerHeight: 0, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer;
        
    }
    
}
