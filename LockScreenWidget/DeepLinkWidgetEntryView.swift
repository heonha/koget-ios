//
//  DeepLinkWidgetEntryView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/04/12.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData
import SFSafeSymbols

// MARK: - Widget View
struct DeepLinkWidgetEntryView: View {

    var entry: DeepLinkProvider.Entry

    @Environment(\.widgetFamily) var family

    let mainURL = "link://"
    let selectWidgetURL = "open://"
    @State var placeholderOpacity: CGFloat = 1
    @StateObject var coreData = WidgetCoreData.shared

    // 위젯 Family에 따라 분기가 가능함(switch)
    @ViewBuilder
    var body: some View {
        ZStack {
            switch family {
            case .accessoryCircular:
                ZStack {
                    // entry에 id가 Set되어 있는경우
                    if entry.id != nil && entry.url != nil {
                        if entry.id == "Ssn2&}g3f`M-Fe.k" { // 스냅샷
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
                            VStack(alignment: .center) {
                                Image(uiImage: entry.image ?? UIImage(systemSymbol: .questionmarkCircle))
                                .resizable()
                                .scaledToFit()
                                .widgetURL(URL(string: "\(mainURL)\(entry.url!)\(WidgetConstant.idSeparator)\(entry.id!)"))
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

            case .systemSmall:
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
                                Image(uiImage: entry.image ?? UIImage(systemSymbol: .questionmarkCircle))
                                .resizable()
                                .scaledToFit()
                                .widgetURL(URL(string: "\(mainURL)\(entry.url ?? "")\(WidgetConstant.idSeparator)\(entry.id ?? "")"))
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
            default:
                VStack {
                    Text("위젯오류")
                }
                .widgetURL(URL(string: selectWidgetURL))
            }
        }
    }
}

// MARK: - Widget Preview
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
