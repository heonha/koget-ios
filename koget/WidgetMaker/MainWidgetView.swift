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
    @State var isPresentHelper = true
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.secondaryBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    // 위젯 만들기 버튼
                    WidgetButtonToMake()
                    
                    // 링크위젯
                    LinkWidgetView()
                }
                
                FloatingButton()
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            
        }
        .tint(tintColor)
    }
}


struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView()
        }
        
    }
}







