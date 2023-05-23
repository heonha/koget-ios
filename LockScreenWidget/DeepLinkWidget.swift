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
    let title: String = S.Widget.Config.title
    let subtitle: String = S.Widget.Config.subtitle

    @ObservedObject var coreData = DeepLinkManager.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DeepLinkAppIntent.self,
            provider: DeepLinkProvider()) { entry in
                DeepLinkWidgetEntryView(entry: entry)
            }
            .configurationDisplayName(title)
            .description(subtitle)
            .supportedFamilies([.accessoryCircular, .systemSmall])
        }
}
