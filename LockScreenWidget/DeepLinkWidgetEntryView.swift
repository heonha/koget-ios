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

    @State var placeholderOpacity: CGFloat = 1
    @ObservedObject var coreData: WidgetCoreData

    @ViewBuilder
    var body: some View {
        ZStack {
            switch family {
            case .accessoryCircular:
                iconWidgetBase
            case .systemSmall:
                iconWidgetBase
            default:
                errorView
            }
        }
        .onAppear {
            self.placeholderOpacity = 0
        }
    }

    var iconWidgetBase: some View {
        ZStack {
            if let id = entry.id, let url = entry.url {
                if entry.id == WidgetConstant.snapshotID { // 스냅샷
                    snapShotView
                } else {
                    iconView(id: id, url: url)
                }
            } else {
                placeHolderView
            }
        }
    }

    var snapShotView: some View {
        VStack {
            Text("바로가기")
                .font(.system(size: 12))
            Text("위젯추가")
                .font(.system(size: 12))
        }
        .bold()
    }

    func iconView(id: String, url: String) -> some View {
        VStack(alignment: .center) {
            Image(uiImage: entry.image ?? UIImage(systemSymbol: .questionmarkCircle))
                .resizable()
                .scaledToFit()
                .widgetURL(URL(string: "\(WidgetConstant.mainURL)\(url)\(WidgetConstant.idSeparator)\(id)"))
                .clipShape(Circle())
                .opacity(0.7)
        }
        .opacity(entry.opacity ?? 1.0)
    }

    var placeHolderView: some View {
        VStack {
            Text("눌러서")
            Text("위젯선택")
        }
        .bold()

    }

    var errorView: some View {
        Text("위젯오류")
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
            DeepLinkWidgetEntryView(entry: entry, coreData: WidgetCoreData.shared)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
