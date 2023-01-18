//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import FloatingButton

// 메인 뷰
struct MainWidgetView: View {
    
    
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
                NewFloatingButton()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("KogetLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
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
