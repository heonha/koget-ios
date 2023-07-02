//
//  GridScrollView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/07/02.
//

import SwiftUI

struct GridScrollView: View {
    
    @EnvironmentObject private var viewModel: HomeWidgetViewModel
    private var gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout) {
                ForEach(viewModel.widgets, id: \.id) { widget in
                    WidgetGridCell(widget: widget)
                }
            }
        }
    }
}

struct GridScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GridScrollView()
            .environmentObject(HomeWidgetViewModel())
    }
}
