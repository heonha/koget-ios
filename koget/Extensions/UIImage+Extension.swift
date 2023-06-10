//
//  UIImage+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import SwiftUI

extension UIImage {

    var toImage: Image {
        return Image(uiImage: self)
    }

    private struct AssociatedKeys {
        static var metadataKey = "metadata"
    }

    var metadata: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.metadataKey) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.metadataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    static func drawClearBackground(size: CGSize) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]

        UIGraphicsBeginImageContext(size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)

        let transparentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return transparentImage
    }

    func addClearBackground(backgroundSize: CGSize,
                            sourceResizeRatio: CGFloat = 0.75) -> UIImage? {

        let width = backgroundSize.width * sourceResizeRatio
        let height = backgroundSize.height * sourceResizeRatio
        let centerX = (backgroundSize.width - width) / 2
        let centerY = (backgroundSize.height - height) / 2

        let replaceCenterSourceImage = CGRect(x: centerX, y: centerY, width: width, height: height)

        UIGraphicsBeginImageContext(backgroundSize)
        let backgroundImage = UIImage.drawClearBackground(size: backgroundSize)
        backgroundImage?.draw(in: CGRect(origin: .zero, size: backgroundSize))
        self.draw(in: replaceCenterSourceImage)
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return combinedImage
    }

}
