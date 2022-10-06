// //
// //  LSWidgetView.swift
// //  BackgroundMaker
// //
// //  Created by HeonJin Ha on 2022/10/05.
// //
// 
// //
// //  LockScreenWidget.swift
// //  LockScreenWidget
// //
// //  Created by HeonJin Ha on 2022/09/30.
// //
// 
// import WidgetKit
// import SwiftUI
// import Intents
// import UIKit
// 
// // let APP_GROUP_ID = "group.ZH5GA3W8UP.com.weizen.BackgroundMaker"
// 
// /// IntentTimelineProvider : 사용자 구성 가능한 위젯의 표시를 업데이트할 때 WidgetKit에 조언하는 유형입니다.
// struct Provider: IntentTimelineProvider {
//     
//     /// 위젯의 자리 표시자 버전을 나타내는 타임라인 항목을 제공합니다.
//     /// 각 위젯에 대해 새 타임라인을 요청 합니다.
//     /// > Properties
//     /// - Context : 크기 및 위젯 갤러리에 표시되는지 여부를 포함하여 위젯이 렌더링되는 방법에 대한 세부 정보가 포함된 개체입니다.
//     ///
//     func placeholder(in context: Context) -> SimpleEntry {
//         SimpleEntry(date: Date(), configuration: ConfigurationIntent())
// 
//     }
// 
//     /// 위젯의 현재 시간과 상태를 나타내는 타임라인 항목을 제공합니다.
//     func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//         let entry = SimpleEntry(date: Date(), configuration: configuration)
//         completion(entry)
//     }
// 
//     /// 콘텐츠가 항상 최신상태인지 확인
//     func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//         var entries: [SimpleEntry] = []
// 
//         // 현재 날짜부터 1시간 간격으로 5개의 항목으로 구성된 타임라인을 생성합니다.
//         let currentDate = Date()
//         for hourOffset in 0 ..< 5 {
//             let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//             let entry = SimpleEntry(date: entryDate, configuration: configuration)
//             entries.append(entry)
//         }
// 
//         /// 콘텐츠가 항상 최신상태인지 확인
//         let timeline = Timeline(entries: entries, policy: .atEnd)
//         completion(timeline)
//     }
// }
// 
// struct SimpleEntry: TimelineEntry {
//     let date: Date
//     let configuration: ConfigurationIntent
// }
// 
// struct LockScreenWidgetEntry: TimelineEntry {
//     let date: Date
//     let image: UIImage
// }
// 
// //MARK: - LockScreen
// @available(iOS 16.0, *)
// struct LockScreenWidgetEntryView : View {
//     
//     @Environment(\.widgetFamily) var widgetFamily
//     
// 
//     var entry: Provider.Entry
//     var lockScreenEntry = LockScreenWidgetEntry(date: Date(), image: UIImage(named: "unnamed")!)
//     
//     private static let deeplinkURL: URL = URL(string: "widget-deeplink://")!
//     
//     func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//         for context in URLContexts {
//             print("url: \(context.url.absoluteURL)")
//             print("scheme: \(context.url.scheme)")
//             print("host: \(context.url.host)")
//             print("path: \(context.url.path)")
//             print("components: \(context.url.pathComponents)")
//         }
//     }
// 
//     
//     var body: some View {
// 
//         // Widget View 조절
//         switch widgetFamily {
//         
//         case .accessoryCircular:
//             VStack {
//                 HStack {
//                     Button(action: {
//                         
//                     }) {
//                         Image("youtube")
//                             .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
//                             .resizable()
//                             .aspectRatio(contentMode: .fit)
//                             .widgetURL(LockScreenWidgetEntryView.deeplinkURL)
//                             .widgetAccentable()
//                     }
// 
//                         // 위젯을 렌더링할 때 위젯의 뷰 계층 구조를 두 그룹(액센트 그룹과 기본 그룹)으로 나눕니다. 그런 다음 각 그룹에 다른 색상을 적용합니다.
//                 }
//             }
//             .privacySensitive() // 민감한 개인 사용자 데이터를 포함하는 것으로 보기를 표시합니다.
//         
//         default:
//             // let groupUD = UserDefaults(suiteName: APP_GROUP_ID)
//             // let testText = groupUD?.object(forKey: "TEST") as? String
//             // Text(testText ?? "NO")
//             Text(entry.date, style: .time)
//                 .widgetURL(LockScreenWidgetEntryView.deeplinkURL)
//         }
//     }
// 
// }
// 
// @available(iOS 16.0, *)
// @main
// /// 이 위젯은 WidgetConfiguration, TimelineProvider 및 SwiftUI를 함께 연결합니다.
// /// 참고: 이 위젯에서 @main을 지정해야 합니다. 그렇지 않으면 코드가 실행되지 않습니다.
// struct LockScreenWidget: Widget {
//     let kind: String = "LockScreenWidget"
// 
//     var body: some WidgetConfiguration {
//         IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//             LockScreenWidgetEntryView(entry: entry)
//         }
//         .configurationDisplayName("위젯 선택")
//         .description("앱에서 설정한 위젯을 선택하세요.")
//         .supportedFamilies([.accessoryCircular]) // 위젯 크기 또는 제품군
//     }
// }
// 
// 
// @available(iOS 16.0, *)
// struct LockScreenWidget_Previews: PreviewProvider {
//     static var previews: some View {
//         
//         // MARK: - 프리뷰할 Widget EntryView 셋업
//         // LockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//         //     .previewContext(WidgetPreviewContext(family: .accessoryInline))
//         //     .previewDisplayName("Inline")
//         // LockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//         //     .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
//         //     .previewDisplayName("Rectangular")
//         LockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//             .previewContext(WidgetPreviewContext(family: .accessoryCircular))
//             .previewDisplayName("Circular")
//             .preferredColorScheme(.light)
//         // LockScreenWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//         //     .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
//         //     .previewDisplayName("Small")
//     }
// }
// //
// // private struct DeepLinkWidgetEntryView: View {
// //     var entry: Provider.Entry
// //
// //     @Environment(\.widgetFamily) var widgetFamily
// //
// //     @ViewBuilder
// //     var body: some View {
// //         if widgetFamily == .systemSmall {
// //             Text("Tap anywhere")
// //                 .widgetURL(deeplinkURL)
// //         } else {
// //             Link("Tap me", destination: deeplinkURL)
// //         }
// //     }
// //
// //     private var deeplinkURL: URL {
// //         URL(string: "widget-DeepLinkWidget://widgetFamily/\(widgetFamily)")!
// //     }
// // }
// //
// // struct DeepLinkWidget: Widget {
// //     private let kind: String = WidgetKind.deepLink
// //
// //     var body: some WidgetConfiguration {
// //         StaticConfiguration(kind: kind, provider: Provider()) { entry in
// //             DeepLinkWidgetEntryView(entry: entry)
// //         }
// //         .configurationDisplayName("DeepLink Widget")
// //         .description("A demo showcasing how to use Deep Links to pass events / information from a Widget to the parent App.")
// //     }
// // }
