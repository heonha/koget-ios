//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetCollectionView: View {
    
    let backgroundColor: Color = .black
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
            VStack {
                // 제목
                WidgetGridView(title: "링크 위젯", widgetCoreData: WidgetCoreData.shared)
            }
        }
        
    }
}
    
    
    struct WidgetListGridView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                WidgetCollectionView()
            }
            .environmentObject(StorageProvider.preview)
        }
    }
