//
//  Color+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/06.
//

import SwiftUI

extension Color {

    init(hex hexcode: String) {
        let scanner = Scanner(string: hexcode)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff

        self.init(red: Double(red) / 0xff, green: Double(green) / 0xff, blue: Double(blue) / 0xff)
    }

}
