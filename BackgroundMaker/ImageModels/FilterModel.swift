//
//  FilterModel.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/27.
//

import UIKit

class FilterModel {
    
    //MARK: - [Todo] Image 가장자리 블러 필터 만들기
    // func makeImageEdgeBlurFilter(image: CIImage) -> CIImage {
    //
    //     print("이미지를 받아옵니다.")
    //
    //         // 이미지의 높이
    //         let imageHeight = image.extent.size.height
    //
    //         // 필터 만들기
    //     print("필터를 만들고 있습니다.")
    //         let topGradientFilter = makeTopBlurFilter(height: imageHeight, startY: 0.8, endY: 0.6)
    //         let bottomGradientFilter = makeTopBlurFilter(height: imageHeight, startY: 0.3, endY: 0.6)
    //
    //         let mergedFilter = mergeFilters(topFilter: topGradientFilter, bottomFilter: bottomGradientFilter)
    //
    //     print("필터를 만들었습니다.")
    //
    //         let filteredImage = applyImageEdgeBlurFilter(blurFilter: topGradientFilter, sourceImage: image)
    //
    //     print("필터를 적용했습니다.")
    //
    //     print("이미지를 반환합니다.")
    //
    //         return filteredImage!
    //
    // }
    
    func makeImageEdgeBlurFilter(image: CIImage) -> CIImage {
        
        print("이미지를 받아옵니다.")

            // 이미지의 높이
            let h = image.extent.size.height
            
            // 필터 만들기
        print("필터를 만들고 있습니다.")
        guard let topGradientFilter = CIFilter(name: FilterName.linearGradient.rawValue ) else {
            fatalError("필터 생성 오류")
        }
        
        topGradientFilter.setValue(CIVector(x:0, y: 0.85 * h), forKey:"inputPoint0")
        topGradientFilter.setValue(CIColor.green, forKey:"inputColor0")
        topGradientFilter.setValue(CIVector(x:0, y: 0.6 * h), forKey:"inputPoint1")
        topGradientFilter.setValue(CIColor(red:0, green:1, blue:0, alpha:0), forKey:"inputColor1")
        
        guard let bottomGradientFilter = CIFilter(name: FilterName.linearGradient.rawValue ) else {
            fatalError("필터 생성 오류")
        }
        
        bottomGradientFilter.setValue(CIVector(x:0, y: 0.3 * h), forKey:"inputPoint0")
        bottomGradientFilter.setValue(CIColor.green, forKey:"inputColor0")
        bottomGradientFilter.setValue(CIVector(x:0, y: 0.6 * h), forKey:"inputPoint1")
        bottomGradientFilter.setValue(CIColor(red:0, green:1, blue:0, alpha:0), forKey:"inputColor1")
        
            
        guard let mergedFilter = CIFilter(name: FilterName.additionCompositing.rawValue) else {
            fatalError("필터 병합 오류")
        }
        
        mergedFilter.setValue(topGradientFilter.outputImage,
                              forKey: kCIInputImageKey)
        mergedFilter.setValue(bottomGradientFilter.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        
        print("필터를 만들었습니다.")

        let filteredImage = applyImageEdgeBlurFilter(blurFilter: topGradientFilter, sourceImage: image)
            
        print("필터를 적용했습니다.")
        
        print("이미지를 반환합니다.")

        return filteredImage!

    }

    /// startY, endY는 그라데이션이 시작하는 지점과 끝나는 지점입니다. 초기값은 녹색 이미지입니다.
    /// 녹색이미지에 그라디언트를 생성하여 녹색 - 하얀색으로 그라디언트 되는 이미지를 만듭니다.
    /// 녹색 부분에는 이미지가 흐림 처리됩니다.
    /// 흰색부분에는 처리가 적용 되지 않습니다.
    ///  start : 0.85, end : 0.6 이라면
    /// 상단 그라디언트를 만들때는 시작점이 크고 끝점이 작게 만드세요.
    /// 하단 그라디언트의 경우에는 시작점이 작고 끝점이 크게 만드세요.
    private func makeTopBlurFilter(height h: CGFloat,
                                   startY: CGFloat, endY: CGFloat) -> CIFilter {
        guard let filter = CIFilter(name: FilterName.linearGradient.rawValue ) else {
            fatalError("필터 생성 오류")
        }
        
        filter.setValue(CIVector(x:0, y: startY * h), forKey:"inputPoint0")
        filter.setValue(CIColor.green, forKey:"inputColor0")
        filter.setValue(CIVector(x:0, y: endY * h), forKey:"inputPoint1")
        filter.setValue(CIColor(red:0, green:1, blue:0, alpha:0), forKey:"inputColor1")
        
        return filter
    }
    
    /// 두개 이상의 필터를 병합합니다.
    private func mergeFilters(topFilter: CIFilter, bottomFilter: CIFilter) -> CIFilter {
        
        guard let mergedFilter = CIFilter(name: FilterName.additionCompositing.rawValue) else {
            fatalError("필터 병합 오류")
        }
        
        mergedFilter.setValue(topFilter.outputImage,
                              forKey: kCIInputImageKey)
        mergedFilter.setValue(bottomFilter.outputImage,
                              forKey: kCIInputBackgroundImageKey)
        
        return mergedFilter
        
    }
    
    
    enum FilterName: String {
        
        /// 이미지에 마스크를 입힙니다.
        case maskedVariableBlur = "CIMaskedVariableBlur"
        
        /// CILinearGradient 가로 라인의 그라디언트를 만듭니다.
        case linearGradient = "CILinearGradient"
        
        /// 다수의 필터를 병합하는 필터입니다.
        case additionCompositing = "CIAdditionCompositing"
        
    }
    
    /// 이미지에 필터 적용하기
    func applyImageEdgeBlurFilter(blurFilter: CIFilter?, sourceImage: CIImage?) -> CIImage? {
        
        guard let maskedVariableBlur = CIFilter(name: FilterName.maskedVariableBlur.rawValue ) else {
            fatalError("필터 적용 오류")
        }
        maskedVariableBlur.setValue(sourceImage, forKey: kCIInputImageKey)
        maskedVariableBlur.setValue(10, forKey: kCIInputRadiusKey)
        maskedVariableBlur.setValue(blurFilter?.outputImage, forKey: "inputMask")
        let selectivelyFocusedCIImage = maskedVariableBlur.outputImage
        
        return selectivelyFocusedCIImage
    }
    
    
}
