//
//  UIView+Utils.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/07.
//

import UIKit

public extension UIView {
    @available(iOS 10.0, *)
    
    ///현재 화면에 보이는 View를 캡쳐하고 Image를 반환합니다.
    func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

        let snapshotImage = renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return snapshotImage
    }
}
