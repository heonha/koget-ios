//
//  WidgetScrollView.swift
//  koget
//
//  Created by Heonjin Ha on 6/12/23.
//

import SwiftUI

enum WidgetViewType {
    case list, grid
}

struct WidgetScrollView: View {

    @Binding var viewType: WidgetViewType
    @ObservedObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData

    var body: some View {
        ScrollView {
            if viewType == .list {
                widgetListView()
            }
            
            if viewType == .grid {
                widgetGridView()
            }
        }
    }

    private func widgetGridView() -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        return LazyVGrid(columns: columns) {
            ForEach($coreData.linkWidgets.wrappedValue, id: \.self) { widget in
                WidgetGridCell(name: widget.name ?? "", url: widget.url ?? "", widgetImage: UIImage(data: widget.image ?? Data()) ?? CommonImages.emptyIcon, viewModel: viewModel)
            }
        }
    }

    // List
    private func widgetListView() -> some View {
        VStack(spacing: 12) {
            ForEach($coreData.linkWidgets.wrappedValue, id: \.self) { widget in
                WidgetListCell(widget: widget, name: widget.name ?? "", url: widget.url ?? "", widgetImage: UIImage(data: widget.image ?? Data()) ?? CommonImages.emptyIcon, runCount: Int(widget.runCount), viewModel: viewModel)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color.clear)
    }

}

#if DEBUG
struct WidgetListView_Previews: PreviewProvider {
    static var previews: some View {

        WidgetScrollView(viewType: .constant(.list), viewModel: .init())
            .environmentObject(WidgetCoreData.shared)
    }
}
#endif
