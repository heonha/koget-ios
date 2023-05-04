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

struct DeepLinkWidget: Widget {

    let kind: String = "LockScreenWidget"
    let title: LocalizedStringKey = "잠금화면 위젯"
    let subtitle: LocalizedStringKey = "아이콘을 눌러 잠금화면에 놓고, 위젯을 선택해주세요."

    @ObservedObject var coreData = WidgetCoreData.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DeepLinkAppIntent.self,
            provider: DeepLinkProvider(coreData: coreData)) { entry in
                DeepLinkWidgetEntryView(entry: entry, coreData: coreData)
            }
            .configurationDisplayName(title)
            .description(subtitle)
            .supportedFamilies([.accessoryCircular, .systemSmall])
        }
}
