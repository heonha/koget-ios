//
//  WidgetCollectionView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct LinkWidgetView: View {
    
    let title: String = "나의 잠금화면 위젯"
    let backgroundColor: Color = AppColors.backgroundColor
    @State var coreData = WidgetCoreData.shared
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea(edges: .bottom)
            VStack {
                // Grid
                WidgetGridView(title: title, widgetCoreData: coreData)
                    .padding()
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
