//
//  Font+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/06.
//

import SwiftUI

extension Font {

    static func custom(_ name: AppFont, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }

}
