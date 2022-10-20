//
//  CustomTextWidget.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/10.
//

import WidgetKit
import SwiftUI
import Intents

//MARK: - Protocol : Provider

@available(iOS 16.0, *)
struct TextWidgetProvider: IntentTimelineProvider {
    
    typealias Entry = TextWidgetEntry
    typealias Intent = TextWidgetIntent
    
    
    func placeholder(in context: Context) -> TextWidgetEntry {
        TextWidgetEntry(date: Date(), text: "테스트 플홀")
    }
    
    func getSnapshot(for configuration: TextWidgetIntent, in context: Context, completion: @escaping (TextWidgetEntry) -> Void) {
        let entry = getContext(context: context)
        completion(entry)
    }
    
    func getTimeline(for configuration: TextWidgetIntent, in context: Context, completion: @escaping (Timeline<TextWidgetEntry>) -> Void) {
        let selectedWidget = configuration.data!
        
        let entry = TextWidgetEntry(date: Date(), text: selectedWidget.text!)
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)

        /// 타임라인을 만들어서 Completion으로 넘깁니다.
        /// > Parameters
        /// - entries : 시간을 담은 배열
        /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    }
    

    /// 위젯을 추가할 때 표시할 프리뷰를 구성합니다.
    func getContext(context: Context) -> TextWidgetEntry {
    
        var entry: TextWidgetEntry
    
        // 위젯 미리보기에서 어떻게 보일 것인지 설정.
        if context.isPreview {
            entry = TextWidgetEntry(date: Date(), text: "테스트")
        } else {
            entry = TextWidgetEntry(date: Date(), text: "테스트")
        }
        return entry
    }
}


struct TextWidgetEntry: TimelineEntry {
    let date: Date
    let text: String?
}


@available(iOS 16.0, *)
struct CustomTextEntryView : View {
    var entry: TextWidgetProvider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        switch family {
        case .accessoryInline:
            Text(entry.text ?? "no data")
                .bold()
        default:
            Text("데이터 없음")
        }
        

    }
}


@available(iOS 16.0, *)
struct UserCustomWidget: Widget {
    let kind: String = "UserCustomWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TextWidgetIntent.self, provider: TextWidgetProvider()) { entry in
            CustomTextEntryView(entry: entry)
        }
        .configurationDisplayName("내 텍스트 위젯")
        .description("앱에서 텍스트 위젯을 구성하고 추가하세요.")
        .supportedFamilies([.accessoryInline])
    }
}

@available(iOS 16.0, *)
struct SimpleWidget_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEntryView(entry: TextWidgetEntry(date: Date(), text: "테스트 프리뷰"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
