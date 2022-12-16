//
//  UIView+Utils.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/07.
//

import UIKit

public extension UIView {
    
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

public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    

}
