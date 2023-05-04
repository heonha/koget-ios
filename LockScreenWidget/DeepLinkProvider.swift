//
//  DeepLinkProvider.swift
//  koget
//
//  Created by Heonjin Ha on 2023/04/12.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData
import SFSafeSymbols

struct DeepLinkEntry: TimelineEntry {
    let date: Date // Widget을 rendering할 Date
    let name: String
    var url: String?
    var image: UIImage?
    var id: String?
    var opacity: Double? = 1.0
}

struct DeepLinkProvider: IntentTimelineProvider {
    typealias Intent = DeepLinkAppIntent
    typealias Entry = DeepLinkEntry
    
    let placeHolderEntry = DeepLinkEntry(date: Date(), name: "Placeholder", url: nil, image: UIImage(systemSymbol: .plus), id: "")
    let snapshotEntry = DeepLinkEntry(date: Date(), name: "Widget Snapshot", url: nil, image: nil, id: WidgetConstant.snapshotID)
    let notSelectedWidgetEntry: DeepLinkEntry = {
        let defaultImage = UIImage(named: "KogetClear") ?? UIImage(systemSymbol: .questionmark)
        return  DeepLinkEntry(date: Date(), name: "선택되지 않음", url: "", image: defaultImage, id: nil, opacity: 1.0)
    }()
    
    @ObservedObject var coreData: WidgetCoreData
    
    func placeholder(in context: Context) -> DeepLinkEntry {
        return self.placeHolderEntry
    }
    
    func getSnapshot(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (DeepLinkEntry) -> Void) {
        completion(self.snapshotEntry)
    }
    
    func getWidgetData(app: AppDefinition, completion: @escaping (UIImage, DeepLink?) -> Void) {
        let deepLink = coreData.linkWidgets.first {
            $0.id?.uuidString == app.identifier ?? WidgetConstant.snapshotID
        }
        
        guard let widget = deepLink else { return }
        
        let image = UIImage(data: widget.image ?? Data()) ?? UIImage(systemSymbol: .plus)
        completion(image, widget)
    }
    
    func getTimeline(for configuration: DeepLinkAppIntent,
                     in context: Context,
                     completion: @escaping (Timeline<DeepLinkEntry>) -> Void) {
        if let app = configuration.app {
            getWidgetData(app: app) { image, deepLink in
                let entry = DeepLinkEntry(
                    date: Date(),
                    name: app.displayString,
                    url: app.url ?? "https://www.google.com",
                    image: image,
                    id: app.identifier,
                    opacity: deepLink?.opacity?.doubleValue ?? 1.0
                )
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        } else {
            // 위젯이 선택되지 않은 경우
            let entry = self.notSelectedWidgetEntry
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
    
}
