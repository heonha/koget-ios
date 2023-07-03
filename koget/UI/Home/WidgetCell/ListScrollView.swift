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
        List(viewModel.widgets, id: \.id) { widget in
            SlideableWidgetCell(widget: widget)
                .listRowBackground(Color.clear)
                .padding(.horizontal, -16)
        }
        .scrollIndicators(.hidden)
        .background(Color.clear)
        .listStyle(.plain)
        .padding(.vertical, 2)
    }
    
    private func slideButton(_ type: SlideableButtonType,
                             action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(type.getBackgroundColor())
                
                Image(systemName: type.getSymbolName())
                    .font(.system(size: 27))
                    .foregroundColor(.init(uiColor: .systemBackground))
            }
        }
        .tint(type.getBackgroundColor())
        .frame(width: 60)
    }
    
}
