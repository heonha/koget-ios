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
        
        // 그래디언트 레이어 초기화
        let maskLayer = CAGradientLayer()

        maskLayer.frame = imageView.bounds
        maskLayer.shadowRadius = 10
        maskLayer.shadowPath = CGPath(roundedRect: imageView.bounds.insetBy(dx: 20, dy: 20), cornerWidth: 0, cornerHeight: 0, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer;
        
    }
    
    
    //MARK: - [Todo] Image 가장자리 블러 필터 만들기
    func makeImageEdgeBlurFilter(image: CIImage?) -> CIImage? {
        
            // 이미지의 높이
        guard let image = image else {return nil}
        
            let imageHeight = image.extent.size.height
            
            // 필터 만들기
            let topGradientFilter = makeTopBlurFilter(height: imageHeight, startY: 0.8, endY: 0.6)
            let bottomGradientFilter = makeTopBlurFilter(height: imageHeight, startY: 0.3, endY: 0.6)
            
            let mergedFilter = mergeFilters(topFilter: topGradientFilter, bottomFilter: bottomGradientFilter)
            
            let filteredImage = applyImageEdgeBlurFilter(blurFilter: mergedFilter, image: image)
            
            return filteredImage

    }

    /// startY, endY는 그라데이션이 시작하는 지점과 끝나는 지점입니다. 초기값은 녹색 이미지입니다.
    /// 녹색이미지에 그라디언트를 생성하여 녹색 - 하얀색으로 그라디언트 되는 이미지를 만듭니다.
    /// 녹색 부분에는 이미지가 흐림 처리됩니다.
    /// 흰색부분에는 처리가 적용 되지 않습니다.
    ///  start : 0.85, end : 0.6 이라면
    /// 상단 그라디언트를 만들때는 시작점이 크고 끝점이 작게 만드세요.
    /// 하단 그라디언트의 경우에는 시작점이 작고 끝점이 크게 만드세요.
    private func makeTopBlurFilter(height h: CGFloat,
                                   startY: CGFloat, endY: CGFloat) -> CIFilter? {
        guard let filter = CIFilter(name:"CILinearGradient") else {
            fatalError("필터 생성 오류")
        }
        
        filter.setValue(CIVector(x:0, y: startY * h), forKey:"inputPoint0")
        filter.setValue(CIColor.green, forKey:"inputColor0")
        filter.setValue(CIVector(x:0, y: endY * h), forKey:"inputPoint1")
        filter.setValue(CIColor(red:0, green:1, blue:0, alpha:0), forKey:"inputColor1")
        
        return filter
    }
    
    private func mergeFilters(topFilter: CIFilter?, bottomFilter: CIFilter?) -> CIFilter? {
        
        guard let mergedFilter = CIFilter(name:"CIAdditionCompositing") else {
            fatalError("필터 병합 오류")
        }
        
        mergedFilter.setValue(topFilter?.outputImage,
                              forKey: kCIInputImageKey)
        mergedFilter.setValue(bottomFilter?.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        
        return mergedFilter
        
    }
    
    func applyImageEdgeBlurFilter(blurFilter: CIFilter?, image: CIImage?) -> CIImage? {
        
        guard let maskedVariableBlur = CIFilter(name:"CIMaskedVariableBlur") else {
            fatalError("필터 적용 오류")
        }
        maskedVariableBlur.setValue(image, forKey: kCIInputImageKey)
        maskedVariableBlur.setValue(10, forKey: kCIInputRadiusKey)
        maskedVariableBlur.setValue(blurFilter?.outputImage, forKey: "inputMask")
        let selectivelyFocusedCIImage = maskedVariableBlur.outputImage
        
        return selectivelyFocusedCIImage
    }
    
}
