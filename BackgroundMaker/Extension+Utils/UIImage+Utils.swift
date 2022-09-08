//
//  UIImage+Utils.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

extension UIImage {
    
    /// 현재 이미지에 가우시안 블러효과를 줍니다. (radius : CGFloat)
    func blurImage(radius: CGFloat = 10) -> UIImage? {
        
        guard let cgImage = cgImage else { return nil }
        /// CGImage 타입을 필터 반영이 가능한 CIImage로 변환합니다..
        let inputCIImage = CIImage(cgImage: cgImage)
        
        /// 필터효과를 구성하고 이미지에 반영합니다.
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        /// 필터가 추가되어 반환된 이미지 입니다.
        let outputImage = filter?.outputImage
        
        ///이미지 처리 결과를 렌더링하고 이미지 분석을 수행하기 위한 평가 컨텍스트입니다.
        let context = CIContext(options: nil)
        
        /// 필터가 추가된 CIImage를 -> CGImage -> UIImage. (context를 참조합니다.)
        if let outputImage = outputImage,
            let cgImage = context.createCGImage(outputImage, from: inputCIImage.extent) {
            
            return UIImage(
                cgImage: cgImage,
                scale: scale,
                orientation: imageOrientation
            )
        }
        return nil
    }
    
    // MARK: - Merge Image
    
    /// 이미지 병합 후보 1
    func mergeImage(with secondImage: UIImage, point: CGPoint? = nil) -> UIImage {

        let firstImage = self
        let newImageWidth = max(firstImage.size.width, secondImage.size.width)
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)
        let deviceScale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, true, deviceScale)

        let firstImagePoint = CGPoint(x: round((newImageSize.width - firstImage.size.width) / 2),
                                      y: round((newImageSize.height - firstImage.size.height) / 2))

        let secondImagePoint = point ?? CGPoint(x: round((newImageSize.width - secondImage.size.width) / 2),
                                                y: round((newImageSize.height - secondImage.size.height) / 2))

        firstImage.draw(at: firstImagePoint)
        secondImage.draw(at: secondImagePoint)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image ?? self
    }
    
    /// 이미지 병합 후보 2
      func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self

        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
      }
}
