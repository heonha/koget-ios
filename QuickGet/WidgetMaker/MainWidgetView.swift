//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData

// 메인 뷰
struct MainWidgetView: View {
    
    var title: String = "위젯"
    var tintColor: Color = .black
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    AppColors.secondaryBackgroundColor
                        .ignoresSafeArea()
                    VStack {
                        WidgetButtonToMake()
                        WidgetCollectionView()
                    }
                    FloatingButton()
                }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            MakeWidgetView()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                    }
                }
                
            }
            .tint(tintColor)
        }
    }
}


struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView()
        }
        .environmentObject(StorageProvider())
        
    }
}







