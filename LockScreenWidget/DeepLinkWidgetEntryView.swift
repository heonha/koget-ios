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

    let addWidgetMessage = S.Widget.emptyPlaceholder
    let selectWidgetMessage = S.Widget.selectWidget
    let errorMessage = S.Widget.error

    @Environment(\.widgetFamily) var widgetFamily

    @ObservedObject var coreData = WidgetCoreData.shared

    @ViewBuilder
    var body: some View {
        ZStack {
            switch widgetFamily {
            case .accessoryCircular:
                iconWidgetBase
            case .systemSmall:
                iconWidgetBase
            default:
                errorView
            }
        }
    }

    var iconWidgetBase: some View {
        ZStack {
            if let id = entry.id, let url = entry.url {
                if entry.id == WidgetConstant.snapshotID {
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
            Text(addWidgetMessage)
        }
        .font(.system(size: 12, weight: .bold))
    }

    func iconView(id: String, url: String) -> some View {
        let image = fetchIcon(id: id)
        return VStack(alignment: .center) {
            Image(uiImage: image)
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
            Text(selectWidgetMessage)
        }
        .bold()
    }

    var errorView: some View {
        Text(errorMessage)
    }

    func fetchIcon(id: String) -> UIImage {
        let widget = coreData.linkWidgets
            .first(where: { $0.id?.uuidString == id })!
        if let imageData = widget.image {
            return UIImage(data: imageData)!
        } else {
            return UIImage(systemSymbol: .xmark)
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
            DeepLinkWidgetEntryView(entry: entry, coreData: WidgetCoreData.shared)
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
