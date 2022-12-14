//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import RxSwift

// 메인 뷰
struct MainWidgetView: View {
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color(uiColor: AppColors.blackDarkGrey)
                        .ignoresSafeArea()
                    VStack {
                        WidgetButtonToMake()
                        WidgetCollectionView()
                    }
                    .padding(.horizontal)
                }
                
                .navigationTitle("위젯")
                .navigationBarTitleDisplayMode(.inline)
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
        .environmentObject(StorageProvider.preview)
    }
}







