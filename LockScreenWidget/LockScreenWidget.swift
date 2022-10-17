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
struct Provider: IntentTimelineProvider {
    typealias Intent = DeepLinkAppIntent
    typealias Entry = DeepLinkEntry
    
    /// 위젯을 추가할 때와 같이 일시적인 상황에 데이터를 전달합니다.
    func getSnapshot(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (DeepLinkEntry) -> Void) {
        let entry = getContext(context: context)
        completion(entry)
    }
    

    
    /// Widget이 업데이트 될 미래 시간을 전달합니다. (미래날짜가 포함된 타임라인 엔트리배열)
    func getTimeline(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (Timeline<DeepLinkEntry>) -> Void) {
        let selectedApp = configuration.app!
        // ID가 같으면 그 이미지를 반환한다.
        
        // 여기에 Simple Entry로 구성된 코드가 보여짐.
        let entry = DeepLinkEntry(
            date: Date(),
            title: selectedApp.displayString ?? "plus.circle",
            link: selectedApp.deepLink ?? "failLink",
            image: WidgetModel.shared.searchImage(id: selectedApp.uuid!),
            id: selectedApp.identifier
        )
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)

        
        /// 타임라인을 만들어서 Completion으로 넘깁니다.
        /// > Parameters
        /// - entries : 시간을 담은 배열
        /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    }
    
    func placeholder(in context: Context) -> DeepLinkEntry {
        DeepLinkEntry(date: Date(), title: "")
    }
    
    /// 위젯을 추가할 때 표시할 프리뷰를 구성합니다.
    func getContext(context: Context) -> DeepLinkEntry {
    
        var entry: DeepLinkEntry
    
        // 위젯 미리보기에서 어떻게 보일 것인지 설정.
        if context.isPreview {
            entry = DeepLinkEntry(date: Date(), title: "placeHolder", link: nil)
        } else {
            entry = DeepLinkEntry(date: Date(), title: "")
        }
        return entry
    }
    
}

//MARK: - Protocol : Entry

/// 위젯을 표시할 시기를 WidgetKit에 알려주는 날짜가 있는 하나 이상의 타임라인 항목을 만듭니다.
struct DeepLinkEntry: TimelineEntry {
    let date: Date // Widget을 rendering할 Date
    let title: String
    var link: String?
    var image: UIImage?
    var id: String?
}

//MARK: - Widget View
struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry
        
    @Environment(\.widgetFamily) var family
    
    let mainURL = "widget-deeplink://"
    
    // 위젯 Family에 따라 분기가 가능함(switch)
    var body: some View {
        
        switch family {
        case .accessoryCircular:
            if entry.title == "placeHolder" {
                VStack(alignment: .center) {
                        Text("바로가기 추가")
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack {
                    Image(uiImage: entry.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .widgetURL(URL(string: "\(mainURL)\(entry.link ?? "failLink")"))
                }
            }
        case .accessoryRectangular:
                Text(entry.id!)
                    .font(Font.caption)
            
                
        default:
            VStack {
                Image("swift")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

//MARK: - MAIN
@main

/// 다양한 종류의 위젯그룹을 만듭니다.
struct Widgets: WidgetBundle {
    var body: some Widget {
        LockScreenWidget()
        UserCustomWidget()
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
        IntentConfiguration(kind: kind, intent: DeepLinkAppIntent.self, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry) // 위젯이 표현할 SwiftUI View입니다.
        }
        .configurationDisplayName("딥링크 위젯")
        .description("앱에서 생성한 위젯을 생성하세요.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular]) // 위젯이 지원하는 위젯의 종류입니다.
    }
}



//MARK: - Widget Preview
/// 위젯 프리뷰 구성
struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetEntryView(entry: DeepLinkEntry(date: Date(), title: "instagram", link: nil))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        
    }
}
