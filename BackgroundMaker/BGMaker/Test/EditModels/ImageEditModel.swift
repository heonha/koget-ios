//
//  ImageEditModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

class ImageEditModel {
    
    //MARK: - Singleton
    static let shared = ImageEditModel()
    
    //MARK: - Init
    private init() {
        
    }
    
    //MARK: - Image Edit General Methods
    
    /// 여러개의 이미지를 병합합니다. (현재는 2개)
    func mergeImages(image: UIImage, imageRect: CGRect, backgroundImage: UIImage) -> UIImage {
        
        let backImage = backgroundImage
        let frontImage = image

        /// 이미지의 기본 판을 형성합니다.
        let screenSize = UIScreen.main.bounds
        let size = CGSize(width: screenSize.width, height: screenSize.height)
        print("DEBUG: 그래픽사이즈: \(size)")

        UIGraphicsBeginImageContext(size)
        
        let backAreaSize = screenSize
        backImage.draw(in: backAreaSize)

        let sourceAreaSize = imageRect
        print(imageRect)
        frontImage.draw(in: sourceAreaSize)


        let mergedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 사용법
        // /// 병합된 이미지를 뷰에 반영합니다.
        // @objc func getMergeImage() {
        //     if let source = self.mainImageView.image, let background = self.bgImageView.image {
        //
        //         let mergedImage = self.imageEditModel
        //             .mergeImages(image: source, imageRect: mainImageView.frame.integral, backgroundImage: background)
        //         self.mainImageView.image = mergedImage
        //     }
        // }

        return mergedImage
    }
    

    //MARK: - Image Capture Methods
    
    /// 해당 하는 뷰만 캡쳐합니다.
    func takeViewCapture(targetView: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetView.bounds.size)
        let image = renderer.image { ctx in
            targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: true)
        }
        return image
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
    
    /// `현재 ViewController를 캡쳐하고 Image를 반환`합니다. (withoutView: 스크린 찍을 동안 숨길 뷰)
    func takeScreenViewCapture(withoutView: [UIView]?, target: UIViewController) -> UIImage? {
        withoutView?.forEach({ views in
            views.isHidden = true
        })
        
        let captureImage = target.view.renderToImage(afterScreenUpdates: true)
        
        withoutView?.forEach({ views in
            views.isHidden = false
        })
        return captureImage
    }
    
    
    //MARK: - Blur Methods

    
    /// 이미지에 블러 효과를 줍니다.
    func makeBlurImage(image: UIImage) -> UIImage {
        return image.blurImage(radius: 40) ?? UIImage()
    }
    
    /// `이미지 끝부분을 블러처리`합니다.Y값은 상하단의 블러 정도를 조절합니다. X값은 좌우 블러값을 설정하며 초기값은 0입니다.
    func makeImageRoundBlur(imageView: UIImageView, insetX: CGFloat = 0, insetY: CGFloat) {
        
        // 그래디언트 레이어 초기화
        let maskLayer = CAGradientLayer()

        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 10
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: insetX, dy: insetY), cornerWidth: 0, cornerHeight: 0, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer
        
    }
    
    // 자연스러운 그레이 스케일 적용
    func convertImageToBW(image: UIImage) -> UIImage {
    
        let filter = CIFilter(name: "CIPhotoEffectMono")
    
        // convert UIImage to CIImage and set as input
    
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
    
        // get output CIImage, render as CGImage first to retain proper UIImage scale
    
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
    
        return UIImage(cgImage: cgImage!)
    }
  
    
}
