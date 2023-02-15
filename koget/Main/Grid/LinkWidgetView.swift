//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct LinkWidgetView: View {
    
    let backgroundColor: Color = AppColors.backgroundColor
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
            VStack {
                // Grid
                WidgetGrid(title: "나의 잠금화면 위젯")
            }
        }
    }
}


struct WidgetListGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LinkWidgetView()
        }
        .environmentObject(StorageProvider(inMemory: true))
    }
}
