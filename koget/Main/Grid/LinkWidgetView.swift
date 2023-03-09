//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import QGrid

struct LinkWidgetView: View {
    
    let backgroundColor: Color = Color("ListBackgroundColor")
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData

    var body: some View {
        ZStack {
            backgroundColor
            VStack {
                if !$coreData.linkWidgets.wrappedValue.isEmpty {
                    if viewModel.isGridView {
                        gridView
                    } else {
                        listView
                    }
                    Spacer()
                } else {
                    EmptyGrid()
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.isGridView)
        }
        .cornerRadius(5)
    }

    var gridView: some View {
        QGrid($coreData.linkWidgets.wrappedValue, columns: 3) { widget in
            WidgetIconCell(widget: widget, viewModel: viewModel, type: .grid)
        }
    }

    var listView: some View {
        VStack {
            List {
                ForEach(coreData.linkWidgets, id: \.id) { widget in
                    WidgetIconCell(widget: widget, viewModel: viewModel, type: .list)
                }
            }
            .listStyle(.plain)
        }
    }
}

struct WidgetListGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LinkWidgetView(viewModel: MainWidgetViewModel.shared)
        }
        .environmentObject(StorageProvider(inMemory: true))
    }
}
