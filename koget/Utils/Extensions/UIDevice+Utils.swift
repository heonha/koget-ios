//
//  UIDevice+Utils.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/10.
//

import UIKit

/// 기기의 종류에 따른 분기
extension UIDevice {
    
    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 || UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }// 아이폰 8보다 낮음
    public var isiPhoneWithoutNotch: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height <= 736 || UIScreen.main.bounds.size.width <= 414) {
            return true
        }
        return false
    }
    
    public var isiPhoneMax: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height <= 736 || UIScreen.main.bounds.size.width <= 414) {
            return true
        }
        return false
    }
    
    public var isiPhoneWithNotch: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height > 736 || UIScreen.main.bounds.size.width > 414) {
            return true
        }
        return false
    }
        
    public var isiPad: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 768) {
            return true
        }
        return false
    }
    public var isiPadPro12: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad && (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366) {
            return true
        }
        return false
    }
}


