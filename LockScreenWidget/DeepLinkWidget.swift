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
        let entry = DeepLinkEntry(date: Date(), name: "", url: nil, image: nil, id: "Ssn2&}g3f`M-Fe.k")

        completion(entry)
    }
    
    func getWidgetData(app: AppDefinition, completion: @escaping (UIImage, DeepLink?) -> Void) {
        var appImage = UIImage(named: "questionmark.circle")!
        var deepLink: DeepLink?
        WidgetCoreData.shared.linkWidgets.contains { appAsset in
            if let appID = app.identifier {
                if appAsset.id?.uuidString == appID {
                    appImage = UIImage(data: appAsset.image!)!
                    deepLink = appAsset

                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        completion(appImage, deepLink)
    }

    /// Widget이 업데이트 될 미래 시간을 전달합니다. (미래날짜가 포함된 타임라인 엔트리배열)
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
            
            let timeline = Timeline(entries: [entry], policy: .never)
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
        
        let entry: DeepLinkEntry = DeepLinkEntry(date: Date(), name: "", url: nil, image: nil, id: nil)
        
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
    var opacity: Double? = 1.0
}

//MARK: - Widget View
struct DeepLinkWidgetEntryView: View {
    var entry: DeepLinkProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    let mainURL = "link://"
    let selectWidgetURL = "open://"
    @State var placeholderOpacity: CGFloat = 1
    @ObservedObject var coreData = WidgetCoreData.shared

    // 위젯 Family에 따라 분기가 가능함(switch)
    @ViewBuilder
    var body: some View {
        
        ZStack {
            // VStack {
            //     Text("바로가기")
            //     Text("위젯추가")
            // }
            // .opacity(placeholderOpacity)
            
            switch family {
            case .accessoryCircular:
                ZStack {
                    // entry에 id가 Set되어 있는경우
                    if entry.id != nil {
                        if entry.id == "Ssn2&}g3f`M-Fe.k" {
                            ZStack {
                                VStack {
                                    Text("바로가기")
                                        .font(.system(size: 12))
                                    Text("위젯추가")
                                        .font(.system(size: 12))
                                }
                                .bold()
                            }
                            
                        } else {
                            // 코어 데이터의 데이터
                            // entry의 데이터
                            // 코어데이터 바뀜 -> 코어데이터 업데이트 -> Entry 업데이트 -> 위젯 업데이트
                            
                            VStack(alignment: .center) {
                                Image(uiImage: entry.image ?? UIImage(systemName: "questionmark.circle")!)
                                .resizable()
                                .scaledToFit()
                                .widgetURL(URL(string: "\(mainURL)\(entry.url!)\(idSeparator)\(entry.id!)"))
                                .clipShape(Circle())
                            }
                            .opacity(entry.opacity ?? 1.0)
                            .opacity(0.7)

                        }
                        
                    } else {
                        ZStack {
                            VStack {
                                Text("눌러서")
                                Text("위젯선택")
                            }
                            .bold()
                        }
                    }
                }
                .onAppear {
                    self.placeholderOpacity = 0
                }
                .onReceive(NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)) { _ in
                    // make sure you don't call this too often
                    WidgetCenter.shared.reloadAllTimelines()
                }

            case .systemSmall:
                ZStack {
                    // entry에 id가 Set되어 있는경우
                    if entry.id != nil {
                        if entry.id == "Ssn2&}g3f`M-Fe.k" {
                                VStack {
                                    Text("바로가기")
                                        .font(.system(size: 12))
                                    Text("위젯추가")
                                        .font(.system(size: 12))
                                }
                                .bold()
                            
                        } else {
                            // 코어 데이터의 데이터
                            // entry의 데이터
                            // 코어데이터 바뀜 -> 코어데이터 업데이트 -> Entry 업데이트 -> 위젯 업데이트
                            
                            VStack(alignment: .center) {
                                Image(uiImage: entry.image ?? UIImage(systemName: "questionmark.circle")!)
                                .resizable()
                                .scaledToFit()
                                .widgetURL(URL(string: "\(mainURL)\(entry.url!)\(idSeparator)\(entry.id!)"))
                                .clipShape(Circle())
                            }
                            .opacity(1)

                        }
                    } else {
                        ZStack {
                            VStack {
                                Text("눌러서")
                                Text("위젯선택")
                            }
                            .bold()
                        }
                    }
                }
            default:
                VStack {
                    Text("위젯오류")
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
    let title: LocalizedStringKey = "바로가기 위젯"
    let subtitle: LocalizedStringKey = "아이콘을 눌러 잠금화면에 놓으세요.\n그리고 코젯 앱에서 생성한 위젯을 선택하세요."
    @ObservedObject var coreData = WidgetCoreData.shared

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
            provider: DeepLinkProvider()) { entry in
                DeepLinkWidgetEntryView(entry: entry) // 위젯이 표현할 SwiftUI View입니다.
                    
            }
            .configurationDisplayName(title)
            .description(subtitle)
            .supportedFamilies([.accessoryCircular, .systemSmall]) // 위젯이 지원하는 위젯의 종류입니다.
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
