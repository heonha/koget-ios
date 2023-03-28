//
//  LockScreenWidgetExtensionBundle.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/28.
//

import WidgetKit
import SwiftUI

// MARK: - MAIN
@main
/// 다양한 종류의 위젯그룹을 만듭니다.
struct Widgets: WidgetBundle {
    var body: some Widget {
        DeepLinkWidget()
    }
}
