//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetCollectionView: View {
    
    @Binding var deepLinkWidgets: [DeepLink]
    
    let backgroundColor: Color = .black
    
    var body: some View {
        ZStack {
            backgroundColor
                .cornerRadius(10)
            VStack {
                WidgetListScrollView(title: "링크 위젯", deepLinkWidgets: $deepLinkWidgets)
                    .padding(4)
            }
        }
    }
}


struct WidgetListGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WidgetCollectionView(deepLinkWidgets: .constant(StorageProvider.preview.linkWidgets))
        }
    }
}
