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

    @ObservedObject var coreData: WidgetCoreData

    // MARK: PlaceHolder
    func placeholder(in context: Context) -> DeepLinkEntry {
        DeepLinkEntry(date: Date(),
                      name: "플레이스 홀더",
                      url: nil,
                      image: UIImage(systemSymbol: .plus),
                      id: "")
    }

    // MARK: getSnapshot
    /// 위젯을 추가할 때와 같이 일시적인 상황에 데이터를 전달합니다.
    func getSnapshot(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (DeepLinkEntry) -> Void) {
        let entry = DeepLinkEntry(date: Date(),
                                  name: "",
                                  url: nil,
                                  image: nil,
                                  id: "Ssn2&}g3f`M-Fe.k")
        completion(entry)
    }

    // MARK: getWidgetData
    func getWidgetData(app: AppDefinition, completion: @escaping (UIImage, DeepLink?) -> Void) {
        let deepLink = coreData.linkWidgets.first {
            $0.id?.uuidString == app.identifier ?? "Ssn2&}g3f`M-Fe.k"
        }
        guard let widget = deepLink else { return }
        let image = UIImage(data: widget.image ?? Data()) ?? UIImage(systemSymbol: .plus)
        completion(image, widget)
    }

    // MARK: getTimeline
    /// Widget이 업데이트 될 미래 시간을 전달합니다. (미래날짜가 포함된 타임라인 엔트리배열)
    ///   /// 타임라인을 만들어서 Completion으로 넘깁니다.
    /// > Parameters
    /// - entries : 시간을 담은 배열
    /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    func getTimeline(for configuration: DeepLinkAppIntent,
                     in context: Context,
                     completion: @escaping (Timeline<DeepLinkEntry>) -> Void) {
        let selectedApp = configuration.app
        // ID가 같으면 그 이미지를 반환한다.

        if let app = selectedApp {
            // 위젯이 선택 된 경우.
            getWidgetData(app: app) { image, deepLink in
                // 여기에 Simple Entry로 구성된 코드가 보여짐.
                let entry = DeepLinkEntry(
                    date: Date(),
                    name: app.displayString,
                    url: app.url!,
                    image: image,
                    id: app.identifier,
                    opacity: deepLink?.opacity?.doubleValue ?? 1.0
                )
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        } else {
            // 위젯이 선택되지 않은 경우
            let defaultImage = UIImage(named: "KogetClear")!
            let entry = DeepLinkEntry(
                date: Date(),
                name: "선택되지 않음",
                url: "",
                image: defaultImage,
                id: nil,
                opacity: 1.0
            )

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }

    }

}

