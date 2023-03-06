//
//  AppColor.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import SwiftUI

enum AppColor {

    enum Background {
        static let first = Color("BackgroundColor")
        static let second = Color("SecondaryBackgroundColor")
        static let third = Color("ThirdBackgroundColor")
    }

    static let deepDarkGrey = Color("deepDarkGray")
    static let normalDarkGrey = Color("normalDarkGrey")

    static let buttonMainColor = Color.init(uiColor: .secondaryLabel)
    static let buttonApplyColor = Color.init(uiColor: .systemBlue)
    static let buttonSecondaryMainColor = Color.init(uiColor: .secondarySystemFill)
    static let destroy = Color("destroy")
    static let darkGray = Color("darkGray")
}
