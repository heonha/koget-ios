//
//  UIDevice+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI

extension UIDevice {

    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    enum DeviceType {
        case unsupport
        case iPhoneSE
        case iPhoneMini
        case iPhone
        case iPhoneMax
    }

    func deviceType() -> DeviceType {
        let screenSizeHeight = UIDevice.screenSize.height
        let screenSizeWidth = UIDevice.screenSize.width

        print("h:\(screenSizeHeight), w:\(screenSizeWidth)")
        if screenSizeHeight < 666 {
            return .unsupport
        } else if screenSizeHeight <= 667 && screenSizeWidth <= 375 {
            return .iPhoneSE
        } else if screenSizeHeight <= 812 && screenSizeWidth <= 375 {
            return .iPhoneMini
        } else if screenSizeHeight <= 852 && screenSizeWidth >= 390 {
            return .iPhone
        } else {
            return .iPhoneMax
        }
    }

}
