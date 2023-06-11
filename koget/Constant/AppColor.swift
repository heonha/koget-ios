//
//  AppColor.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/03.
//

import SwiftUI

enum AppColor {

    enum Background {
        static let first = Color.init(uiColor: .systemBackground)
        static let second = Color.init(uiColor: .secondarySystemBackground)
        static let third = Color.init(uiColor: .tertiarySystemBackground)
    }

    enum Label {
        static let first = Color.init(uiColor: .label)
        static let second = Color.init(uiColor: .secondaryLabel)
        static let third = Color.init(uiColor: .tertiaryLabel)
        static let fourth = Color.init(uiColor: .quaternaryLabel)
    }

    enum Behavior {
        static let errorRed = Color("errorRed")
        static let toggleLight = Color("toggleLight")
    }

    enum Accent {
        static let primary = Color("PrimaryAccent")
    }

    enum Fill {
        static let first = Color.init(uiColor: .systemFill)
        static let second = Color.init(uiColor: .secondarySystemFill)
        static let third = Color.init(uiColor: .tertiarySystemFill)
    }

    enum GrayFamily {
        static let dark1 = Color(hex: "404040")
    }

    static let kogetBlue = Color("kogetBlue")
    static let kogetRed = Color("kogetRed")

}
