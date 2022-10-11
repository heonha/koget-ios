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
struct CustomTextProvider: IntentTimelineProvider {
    
    typealias Entry = UserCustomEntry
    typealias Intent = CustomTextIntent
    
    
    func placeholder(in context: Context) -> UserCustomEntry {
        UserCustomEntry(date: Date(), text: "테스트 플홀")
    }
    
    func getSnapshot(for configuration: CustomTextIntent, in context: Context, completion: @escaping (UserCustomEntry) -> Void) {
        let entry = getContext(context: context)
        completion(entry)
    }
    
    func getTimeline(for configuration: CustomTextIntent, in context: Context, completion: @escaping (Timeline<UserCustomEntry>) -> Void) {
        let entry = UserCustomEntry(date: Date(), text: "테스트 타임라인😍")
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)

        /// 타임라인을 만들어서 Completion으로 넘깁니다.
        /// > Parameters
        /// - entries : 시간을 담은 배열
        /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    }
    

    /// 위젯을 추가할 때 표시할 프리뷰를 구성합니다.
    func getContext(context: Context) -> UserCustomEntry {
    
        var entry: UserCustomEntry
    
        // 위젯 미리보기에서 어떻게 보일 것인지 설정.
        if context.isPreview {
            entry = UserCustomEntry(date: Date(), text: "테스트")
        } else {
            entry = UserCustomEntry(date: Date(), text: "테스트")
        }
        return entry
    }
}


struct UserCustomEntry: TimelineEntry {
    let date: Date
    let text: String?
}


@available(iOS 16.0, *)
struct CustomTextEntryView : View {
    var entry: CustomTextProvider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        switch family {
        case .accessoryInline:
            Text(entry.text ?? "no data")
                .bold()
            
        case .accessoryRectangular:
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
        IntentConfiguration(kind: kind, intent: CustomTextIntent.self, provider: CustomTextProvider()) { entry in
            CustomTextEntryView(entry: entry)
        }
        .configurationDisplayName("내 텍스트 위젯")
        .description("앱에서 텍스트 위젯을 구성하고 추가하세요.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline])
    }
}

@available(iOS 16.0, *)
struct SimpleWidget_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEntryView(entry: UserCustomEntry(date: Date(), text: "테스트 프리뷰"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
