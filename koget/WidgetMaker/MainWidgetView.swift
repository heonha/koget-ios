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
    @State var isOpen = false
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
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
                NewFloatingButton(isOpen: $isOpen)
                
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
                    HowToUseMenu()
                }
                
            }
            .onTapGesture {
                isOpen = false
            }
            .onDisappear {
                print("Disappear")
                isOpen = false
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
