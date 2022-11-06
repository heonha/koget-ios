//
//  EditImageModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

class EditImageModel {
    
    //MARK: - Singleton
    static let shared = EditImageModel()
    
    //MARK: - Init
    private init() {
        
    }

    //MARK: - Image Capture Methods
    
    /// 목적 뷰만 캡쳐
    func takeViewCapture(targetView: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetView.bounds.size)
        let image = renderer.image { ctx in
            targetView.drawHierarchy(in: targetView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    /// 이미지 공유 뷰컨트롤러 띄우기.(ActivityViewController)
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
    
    /// ViewController 캡쳐기능.  필요없는 뷰는 숨길 수 있음.
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
    
    /// UIImage 자체에 블러필터 적용
    func makeBlurImage(image: UIImage, radius: CGFloat = 40) -> UIImage {
        return image.blurImage(radius: radius) ?? UIImage()
    }
    
    /// 이미지 상하단 엣지 블러처리 기능.
    /// - Y값은 상하단의 블러 정도를 조절합니다.
    /// - X값은 좌우 블러값을 설정하며 초기값은 0입니다.
    func makeImageRoundBlur(imageView: UIImageView, insetX: CGFloat = 0, insetY: CGFloat) {
        
        if insetY == 0 {
            imageView.layer.mask = nil
            return
        }

        let maskLayer = CAGradientLayer()

        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 10
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: insetX, dy: insetY), cornerWidth: 0, cornerHeight: 0, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer
        
    }
    
    
    /// 자연스러운 그레이 스케일 적용 (mono 필터)
    func convertImageToBW(image: UIImage) -> UIImage {
    
        let filter = CIFilter(name: "CIPhotoEffectMono")
    
        // convert UIImage to CIImage and set as input
    
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")
    
        // get output CIImage, render as CGImage first to retain proper UIImage scale
    
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)!
    
        return UIImage(cgImage: cgImage)
    }
  
    
}
