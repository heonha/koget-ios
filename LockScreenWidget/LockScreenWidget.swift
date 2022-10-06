//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Created by HeonJin Ha on 2022/10/05.
//

import WidgetKit
import SwiftUI
import Intents
//MARK: - Protocol : Provider

/// 위젯의 업데이트 시기를 WidgetKit에 알려줍니다.
/// WidgetKit은 업데이트 시기를 Provider에 요청합니다.
/// > WidgetKit이 요청하는 것
/// - Snapshot : Widget의 현재상태를 나타내는 스탭샷
/// - Timeline : Widget이 변경될 미래 날짜.
/// - context : Widget이 렌더링되는 방법에 대한 세부정보가 포함된 객체
///
struct Provider: IntentTimelineProvider {
    typealias Intent = ViewIconIntent
    typealias Entry = SimpleEntry
    
    /// Widget의 현재상태를 전달합니다.
    /// 위젯을 추가할 때와 같이 일시적인 상황에 데이터를 전달합니다.
    func getSnapshot(for configuration: ViewIconIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), title: "Snap")
        completion(entry)
    }
    
    
    /// Widget이 업데이트 될 미래 시간을 전달합니다. (미래날짜가 포함된 타임라인 엔트리배열)
    func getTimeline(for configuration: ViewIconIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let selectedApp = configuration.app?.displayString
        let deepLink = configuration.app?.identifier
        let entry = SimpleEntry(date: Date(), title: selectedApp ?? "swift", link: deepLink ?? "no")
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)

        
        // 현재 날짜부터 1시간 간격으로 5개의 항목으로 구성된 타임라인을 생성합니다.
        // let currentDate = Date() // 1. 현재날짜.
        
        // for hourOffset in 0 ..< 5 { // 5개항목으로 구성된 타임라인
        //     let entryDate = Calendar.current
        //         .date(byAdding: .minute,
        //               value: hourOffset,
        //               to: currentDate)! // 1시간 간격으로 업데이트
        //     let entry = SimpleEntry(date: entryDate, title: "SimpleEntry GetTimeLine")
        //     entries.append(entry)
        // } // end hourOffset
        
        /// 타임라인을 만들어서 Completion으로 넘깁니다.
        /// > Parameters
        /// - entries : 시간을 담은 배열 (1시간간격 5개항목)
        /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    }
    
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "")
    }
    

    // func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    //     let entry = getContext(context: context)
    //
    //     completion(entry)
    // }
    
    
    /// 내가 만든 것!
    // func getContext(context: Context) -> SimpleEntry {
    //
    //     var entry: SimpleEntry
    //
    //     // // 위젯 미리보기에서 어떻게 보일 것인지 설정.
    //     // if context.isPreview {
    //     //     entry = SimpleEntry(date: Date(), title: "Goo")
    //     // } else {
    //     //     entry = SimpleEntry(date: Date(), title: "")
    //     // }
    //
    //     print(entry.title)
    //
    //     return entry
    // }
    
    func selectedApp(for configuration: ViewIconIntent) -> String {
        let selected = configuration.app!.app!
        return selected
    }
    
    // func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    //     var entries: [SimpleEntry] = []
    //
    //     // 현재 날짜부터 1시간 간격으로 5개의 항목으로 구성된 타임라인을 생성합니다.
    //     let currentDate = Date() // 1. 현재날짜.
    //
    //     for hourOffset in 0 ..< 5 { // 5개항목으로 구성된 타임라인
    //         let entryDate = Calendar.current
    //             .date(byAdding: .minute,
    //                   value: hourOffset,
    //                   to: currentDate)! // 1시간 간격으로 업데이트
    //         let entry = SimpleEntry(date: entryDate, title: "SimpleEntry Offset")
    //         entries.append(entry)
    //     } // end hourOffset
    //
    //     /// 타임라인을 만들어서 Completion으로 넘깁니다.
    //     /// > Parameters
    //     /// - entries : 시간을 담은 배열 (1시간간격 5개항목)
    //     /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    //     let timeline = Timeline(entries: entries, policy: .atEnd)
    //     completion(timeline)
    // }
    
    
    
}

//MARK: - Protocol : Entry

/// 위젯을 표시할 시기를 WidgetKit에 알려주는 날짜가 있는 하나 이상의 타임라인 항목을 만듭니다.
struct SimpleEntry: TimelineEntry {
    let date: Date // Widget을 rendering할 Date
    let title: String
    var link: String?
}



//TimelineEntry를 준수하는 구조를 선언할 때 구성의 콘텐츠 블록이 위젯을 렌더링하는 데 필요한 추가 정보를 포함합니다.
// 다음 코드는 게임 캐릭터의 건강 수준을 표시하는 위젯의 타임라인 항목 구조를 보여줍니다.
//
// struct CharacterDetailEntry: TimelineEntry {
//     var date: Date
//     var healthLevel: Double // Health Level
// }

// 위젯 구성의 콘텐츠 블록은 항목을 매개변수로 받은 다음 위젯을 렌더링하는 뷰에 관련 정보를 전달합니다.
// struct CharacterDetailWidget: Widget {
//     var body: some WidgetConfiguration {
//         StaticConfiguration(
//             kind: "com.mygame.character-detail",
//             provider: CharacterDetailProvider()) { entry in
//             CharacterDetailView(entry: entry)
//         }
//         .configurationDisplayName("Character Details")
//         .description("Displays a character's health and other details")
//         .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
//     }
// }


//MARK: - Widget View
struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    let mainURL = "widget-deeplink://"
    
    // 위젯 Family에 따라 분기가 가능함(switch)
    var body: some View {
        
        switch family {
        case .accessoryCircular:
            VStack {
                    Image(entry.title)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .widgetURL(URL(string: "\(mainURL)\(entry.link!)"))
            }
        default:
            VStack {
                Text("Not")
            }
        }

        // Widget View 조절
    //MARK: [Todo]
    // 클릭했을때 앱에 데이터를 전달해야하고
    // 위젯 구성 시 누른 것에 대한 데이터를 받아 위젯 타임라인에 업데이트해야하고
        // Button(action: {
        //
        // }) {
        //     Image(AppList.shared.app.first!.iconName)
        //         .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
        //         .resizable()
        //         .aspectRatio(contentMode: .fit)
        //         .widgetURL(youtubeURL)
        //         .widgetAccentable()
        // }.privacySensitive() // 민감한 개인 사용자 데이터를 포함하는 것으로 보기를 표시합니다.
        //
        // 위젯을 렌더링할 때 위젯의 뷰 계층 구조를 두 그룹(액센트 그룹과 기본 그룹)으로 나눕니다. 그런 다음 각 그룹에 다른 색상을 적용합니다.
        

        
    }
}

@main

/// 다양한 종류의 위젯그룹을 만듭니다.
struct Widgets: WidgetBundle {
    var body: some Widget {
        LockScreenWidget()
        // TestScreenWidget()
    }
}



//MARK: - Protocol : Widget

/// Widget : Widget의 컨텐츠를 나타내는 configuration 프로토콜
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    /// 위젯의 Contents를 나타냅니다.
    var body: some WidgetConfiguration {
        
        /// Static Configuration : 사용자가 커스텀 할 수 없는 정적인 위젯
        /// 구성 : Kind, provider, entry
        /// kind : 위젯의 식별자. 즉, ID입니다.
        /// provider : 위젯을 새로고침할 타임라인을 결정하는 객체
        /// content (entry) : getSnapshot, getTimeline을 전달하고 위젯을 렌더링합니다.
        IntentConfiguration(kind: kind, intent: ViewIconIntent.self, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry) // 위젯이 표현할 SwiftUI View입니다.
        }
        .configurationDisplayName("딥링크 위젯")
        .description("앱에서 생성한 위젯을 생성하세요.")
        .supportedFamilies([.accessoryCircular, .systemSmall]) // 위젯이 지원하는 위젯의 종류입니다.
        
    }
}

/// Widget : Widget의 컨텐츠를 나타내는 configuration 프로토콜
struct TestScreenWidget: Widget {
    let kind: String = "TestScreenWidget"
    
    /// 위젯의 Contents를 나타냅니다.
    var body: some WidgetConfiguration {
        
        /// Static Configuration : 사용자가 커스텀 할 수 없는 정적인 위젯
        /// 구성 : Kind, provider, entry
        /// kind : 위젯의 식별자. 즉, ID입니다.
        /// provider : 위젯을 새로고침할 타임라인을 결정하는 객체
        /// content (entry) : getSnapshot, getTimeline을 전달하고 위젯을 렌더링합니다.
        IntentConfiguration(kind: kind, intent: ViewIconIntent.self, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry) // 위젯이 표현할 SwiftUI View입니다.
        }
        .configurationDisplayName("테스트 스크린위젯")
        .description("앱에서 생성한 위젯을 생성하세요.")
        .supportedFamilies([.accessoryCircular, .systemSmall]) // 위젯이 지원하는 위젯의 종류입니다.
        
    }
}

//MARK: - Widget Preview
/// 위젯 프리뷰 구성
struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), title: "instagram", link: nil))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
