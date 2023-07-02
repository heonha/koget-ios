//
//  OverlayHomeWidgetView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/07/02.
//

import SwiftUI

struct OverlayHomeWidgetView: View {
    
    @EnvironmentObject private var viewModel: HomeWidgetViewModel
    
    var body: some View {
        if viewModel.showDetail {
            if let widget = viewModel.targetWidget {
                ZStack {
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .blur(radius: 4)
                        .ignoresSafeArea()
                    DetailWidgetView(selectedWidget: widget)
                }
                .onDisappear {
                    viewModel.fetchAllWidgets()
                }
            }
        }
    }
    
}



private func overlayDetailView(widget: DeepLink?) -> some View {
    Group {

    }
}
