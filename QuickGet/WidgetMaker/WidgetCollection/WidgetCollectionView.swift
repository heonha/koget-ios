//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetCollectionView: View {
    
    let title: String = "나의 위젯"
    let backgroundColor: Color = AppColors.backgroundColor
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
            VStack {
                // 제목
                WidgetGridView(title: title, widgetCoreData: WidgetCoreData.shared)
                    .padding(.horizontal)
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
