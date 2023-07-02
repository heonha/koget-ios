//
//  ListScrollView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/07/02.
//

import SwiftUI

struct ListScrollView: View {
    
    @EnvironmentObject private var viewModel: HomeWidgetViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach($viewModel.widgets, id: \.id) { widget in
                    SlideableWidgetCell(widget: widget.wrappedValue)
                }
            }
            .padding(.vertical, 2)
        }

    }
    
}
