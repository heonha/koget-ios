//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import RxSwift

struct WidgetCollectionView: View {
    
    let backgroundColor: Color = .black
    
    var body: some View {
        ZStack {
            backgroundColor
                .cornerRadius(10)
            VStack {
                // 제목
                WidgetListScrollView(title: "링크 위젯")
                    .padding(4)
            }
        }
        
    }
}
    
    
    struct WidgetListGridView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                WidgetCollectionView()
            }
            .environmentObject(StorageProvider.preview.self)
        }
    }
