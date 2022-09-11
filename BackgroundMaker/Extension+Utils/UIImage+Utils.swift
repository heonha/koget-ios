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

}
