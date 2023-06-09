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

    @ObservedObject var coreData = WidgetCoreData.shared

    let placeHolderEntry = Entry(date: Date(), name: "Placeholder", url: nil, image: nil, id: "")
    let snapshotEntry = Entry(date: Date(), name: "Widget Snapshot", url: nil, image: nil, id: WidgetConstant.snapshotID)
    let notSelectedWidgetEntry: Entry = {
        let defaultImage = CommonImages.koget
        return  Entry(date: Date(), name: "선택되지 않음", url: "", image: defaultImage, id: nil, opacity: 1.0)
    }()

    func placeholder(in context: Context) -> Entry {
        return self.placeHolderEntry
    }

    func getSnapshot(for configuration: Intent,
                     in context: Context,
                     completion: @escaping (Entry) -> Void) {
        completion(self.snapshotEntry)
    }

    func getTimeline(for configuration: Intent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> Void) {

        let app = configuration.app
        let selectedLink = coreData.linkWidgets.first {
            $0.id?.uuidString == app?.identifier ?? WidgetConstant.snapshotID
        }

        let image = UIImage(data: selectedLink?.image ?? Data()) ?? UIImage(systemSymbol: .plus)
        let entry = Entry(
            date: Date(),
            name: app?.displayString ?? "Loading",
            url: app?.url ?? "link://",
            image: image,
            id: app?.identifier,
            opacity: selectedLink?.opacity?.doubleValue ?? 1.0
        )

        completion(Timeline(entries: [entry], policy: .never))
    }

}
