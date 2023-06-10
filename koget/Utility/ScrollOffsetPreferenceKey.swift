//
//  ScrollOffsetPreferenceKey.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}
