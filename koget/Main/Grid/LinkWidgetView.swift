//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import QGrid

struct LinkWidgetView: View {
    
    let backgroundColor: Color = AppColors.backgroundColor
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
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
    }

    var gridView: some View {
        QGrid($coreData.linkWidgets.wrappedValue, columns: 3) { widget in
            WidgetIconCell(widget: widget, viewModel: viewModel, type: .grid)
        }
    }

    var listView: some View {
        VStack {
            if viewModel.isEditMode == .active {
                HStack {
                    ForEach(viewModel.selection) { widget in
                        Image(uiImage: .init(data: widget.image!) ?? UIImage(named: "questionmark.circle")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                }
            }
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
