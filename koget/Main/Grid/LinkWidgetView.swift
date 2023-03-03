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
                // 그리드뷰
                
                if !$coreData.linkWidgets.wrappedValue.isEmpty {
                    
                    if viewModel.isGridView {
                        
                        //MARK: - Grid View
                            QGrid($coreData.linkWidgets.wrappedValue, columns: 3) { widget in
                                WidgetIconCell(widget: widget, viewModel: viewModel, type: .grid)
                        }
                        
                    } else {
                        //MARK: - List View
                        List(coreData.linkWidgets, id: \.id) { widget in
                                WidgetIconCell(widget: widget, viewModel: viewModel, type: .list)
                        }
                        .listStyle(.plain)
                        
                    }
                    Spacer()

                } else {
                    
                    EmptyGrid()
                    
                }
                
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.isGridView)
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
