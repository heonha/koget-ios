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

    enum Label {
        static let first = Color("LabelColor")
        static let second = Color("SecondaryLabelColor")
        static let third = Color("ThirdLabelColor")
    }

    enum Behavior {
        static let errorRed = Color("ErrorRed")
        static let toggleLight = Color("toggleLight")

    }

    enum Accent {
        static let primary = Color("PrimaryAccent")
    }

    static let deepDarkGrey = Color("deepDarkGray")
    static let normalDarkGrey = Color("normalDarkGrey")
    static let buttonMainColor = Color.init(uiColor: .secondaryLabel)
    static let buttonApplyColor = Color.init(uiColor: .systemBlue)
    static let buttonSecondaryMainColor = Color.init(uiColor: .secondarySystemFill)
    static let destroy = Color("destroy")
    static let darkGray = Color("darkGray")
}
