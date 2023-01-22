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
struct DeepLinkProvider: IntentTimelineProvider {
    typealias Intent = DeepLinkAppIntent
    typealias Entry = DeepLinkEntry
    
    /// 위젯을 추가할 때와 같이 일시적인 상황에 데이터를 전달합니다.
    func getSnapshot(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (DeepLinkEntry) -> Void) {
        let entry = getContext(context: context)
        completion(entry)
    }
    
    func getWidgetImage(id: String?) -> UIImage {
        
        // 딥링크 앱의 배열을 가져온다.
        let deepLinkApps = WidgetCoreData.shared.getStoredDataForDeepLink()!
        
        var appImage = UIImage(named: "questionmark.circle")!
        
        for apps in deepLinkApps {
            if id == apps.id?.uuidString {
                appImage = UIImage(data: apps.image!)!
                return appImage
            }
        }
        return appImage
    }
    
    /// Widget이 업데이트 될 미래 시간을 전달합니다. (미래날짜가 포함된 타임라인 엔트리배열)
    func getTimeline(for configuration: DeepLinkAppIntent, in context: Context, completion: @escaping (Timeline<DeepLinkEntry>) -> Void) {
        let selectedApp = configuration.app
        // ID가 같으면 그 이미지를 반환한다.
        
        if let app = selectedApp {
            
            // 여기에 Simple Entry로 구성된 코드가 보여짐.
            let entry = DeepLinkEntry(
                date: Date(),
                name: app.displayString,
                url: app.url!,
                image: getWidgetImage(id: app.identifier),
                id: app.identifier
            )
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            
            completion(timeline)
            
        } else {
            let defaultImage = UIImage(named: "trash")!
            let entry = DeepLinkEntry(
                date: Date(),
                name: "선택되지 않음",
                url: "",
                image: defaultImage,
                id: nil
            )
            
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
            
        }
        
        
        
        /// 타임라인을 만들어서 Completion으로 넘깁니다.
        /// > Parameters
        /// - entries : 시간을 담은 배열
        /// - policy : (TimelineReloadPolicy) 타임라인의 마지막 이후 새 타임라인을 요청하는 정책
    }
    
    func placeholder(in context: Context) -> DeepLinkEntry {
        DeepLinkEntry(date: Date(), name: "플레이스 홀더", url: nil, image: UIImage(named: "test.icon.1")!, id: "")
    }
    
    /// 위젯을 추가할 때 표시할 프리뷰를 구성합니다.
    func getContext(context: Context) -> DeepLinkEntry {
        
        let entry: DeepLinkEntry = DeepLinkEntry(date: Date(), name: "", url: nil, image: UIImage(named: "trash")!, id: nil)
        
        return entry
    }
    
}

//MARK: - Protocol : Entry

/// 위젯을 표시할 시기를 WidgetKit에 알려주는 날짜가 있는 하나 이상의 타임라인 항목을 만듭니다.
struct DeepLinkEntry: TimelineEntry {
    let date: Date // Widget을 rendering할 Date
    let name: String
    var url: String?
    var image: UIImage?
    var id: String?
}

//MARK: - Widget View
struct DeepLinkWidgetEntryView : View {
    var entry: DeepLinkProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    let mainURL = "link://"
    let selectWidgetURL = "open://"
    
    // 위젯 Family에 따라 분기가 가능함(switch)
    @ViewBuilder
    var body: some View {
        
        ZStack {
            
            switch family {
            case .accessoryCircular:
                
                // entry에 id가 Set되어 있는경우
                if entry.id != nil {
                    VStack(alignment: .center) {
                        Image(uiImage: entry.image
                              ?? UIImage(systemName: "questionmark.circle")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .widgetURL(URL(string: "\(mainURL)\(entry.url!)"))
                            .grayscale(0.99)
                            .contrast(-3)
                            .clipShape(Circle())
                    }
                    .opacity(0.7)
                } else {
                    ZStack {
                        VStack {
                            Text("위젯")
                            Text("선택")
                        }
                        .bold()
                        .widgetURL(URL(string: selectWidgetURL))
                    }
                }
            default:
                VStack {
                    Text("Error")
                }
                .widgetURL(URL(string: selectWidgetURL))
            }
        }
        
        
    }
    
    
}

//MARK: - MAIN
@main

/// 다양한 종류의 위젯그룹을 만듭니다.
struct Widgets: WidgetBundle {
    var body: some Widget {
        DeepLinkWidget()
    }
}

//MARK: - Protocol : Widget

/// Widget : Widget의 컨텐츠를 나타내는 configuration 프로토콜
struct DeepLinkWidget: Widget {
    let kind: String = "LockScreenWidget"
    
    /// 위젯의 Contents를 나타냅니다.
    var body: some WidgetConfiguration {
        
        /// Static Configuration : 사용자가 커스텀 할 수 없는 정적인 위젯
        /// 구성 : Kind, provider, entry
        /// kind : 위젯의 식별자. 즉, ID입니다.
        /// provider : 위젯을 새로고침할 타임라인을 결정하는 객체
        /// content (entry) : getSnapshot, getTimeline을 전달하고 위젯을 렌더링합니다.
        IntentConfiguration(
            kind: kind,
            intent: DeepLinkAppIntent.self,
            provider: DeepLinkProvider()) { (entry) in
                DeepLinkWidgetEntryView(entry: entry) // 위젯이 표현할 SwiftUI View입니다.
            }
            .configurationDisplayName("딥링크 위젯")
            .description("앱에서 생성한 위젯을 생성하세요.")
            .supportedFamilies([.accessoryCircular]) // 위젯이 지원하는 위젯의 종류입니다.
    }
}



//MARK: - Widget Preview
/// 위젯 프리뷰 구성
struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        let entrys = [DeepLinkEntry(date: Date(), name: "카카오톡", url: "kakaotalk://", image: UIImage(named: "tmap")!, id: UUID().uuidString),
                      DeepLinkEntry(date: Date(), name: "카카오톡", url: "kakaotalk://", image: UIImage(named: "instagram")!, id: UUID().uuidString)
                      
        ]
        
        ForEach(entrys, id: \.id) { entry in
            DeepLinkWidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))

        }
        
    }
}
