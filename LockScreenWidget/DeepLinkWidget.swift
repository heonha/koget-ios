//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Created by HeonJin Ha on 2022/10/05.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

// MARK: - Protocol : Widget
/// Widget : Widget의 컨텐츠를 나타내는 configuration 프로토콜
struct DeepLinkWidget: Widget {

    let kind: String = "LockScreenWidget"
    let title: LocalizedStringKey = "잠금화면 위젯"
    let subtitle: LocalizedStringKey = "아이콘을 눌러 잠금화면에 놓고, 위젯을 선택해주세요."

    @StateObject var coreData = WidgetCoreData.shared

    /// 위젯의 Contents를 나타냅니다.
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DeepLinkAppIntent.self,
                            provider: DeepLinkProvider(coreData: coreData) ) { entry in
                DeepLinkWidgetEntryView(entry: entry)
                .environmentObject(coreData)
            }
            .configurationDisplayName(title)
            .description(subtitle)
            .supportedFamilies([.accessoryCircular, .systemSmall])
    }
}

