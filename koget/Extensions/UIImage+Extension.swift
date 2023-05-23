//
//  UIImage+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import SwiftUI

extension UIImage {

    func compressPNGData(newSize: CGSize = CGSize(width: 128, height: 128)) -> Data? {

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // PNG 데이터 생성
        return newImage?.pngData()
    }

}
