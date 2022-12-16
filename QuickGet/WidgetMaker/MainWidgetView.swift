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
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    AppColors.blackDarkGrey
                        .ignoresSafeArea()
                    VStack {
                        WidgetButtonToMake()
                        WidgetCollectionView()
                    }
                    
                    FloatingButton()
                }
                .navigationTitle("위젯")
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
            .tint(.white)
        }
    }
}


struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView()
        }
        
    }
}







