//
//  UIImage+Utils.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/06.
//

import UIKit

extension UIImage {
    
    /// 현재 이미지에 가우시안 블러효과를 줍니다. (radius : CGFloat)
    func blurImage(radius: CGFloat = 40) -> UIImage? {
        
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

    /// 이미지에 그림자를 추가합니다.
    func addShadow(blurSize: CGFloat = 7.0, color: UIColor) -> UIImage {
                    
        let shadowColor = color.cgColor
        
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: self.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.setShadow(offset: CGSize(width: blurSize/2,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(self.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: self.size.width, height: self.size.height),
                     byTiling:false)
        
        return UIImage(cgImage: context.makeImage()!)
    }

    var grayscaled: UIImage?{
        let ciImage = CIImage(image: self)
        let grayscale = ciImage?.applyingFilter("CIColorControls",
                                                parameters: [ kCIInputSaturationKey: 0.0 ])
        if let gray = grayscale{
            return UIImage(ciImage: gray)
        }
        else{
            return nil
        }
    }
}
