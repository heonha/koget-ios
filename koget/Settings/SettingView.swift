//
//  SettingView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/25.
//

import SwiftUI

struct SettingView: View {
    
    @State var isAlertPresent: Bool = false
    @State var isOn: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.secondaryBackgroundColor
                .ignoresSafeArea()
            List {
                
                NavigationLink {
                    NoticeList()
                } label: {
                    SettingButtonLabel(
                        title: "공지사항",
                        symbolName: "exclamationmark.bubble"
                    )
                }
                
                NavigationLink {
                    ContactView()
                } label: {
                    SettingButtonLabel(
                        title: "문의하기",
                        symbolName: "mail")
                }
                
                HStack {
                    Text("코젯 버전")
                        .foregroundColor(AppColors.label)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(AppColors.darkGray)
                        .bold()
                }
                .foregroundColor(.gray)
            }
            .alert("미구현", isPresented: $isAlertPresent, actions: {
                
            })
            .padding(.top, 4)
            .navigationTitle("앱 설정")
            .navigationBarTitleDisplayMode(.large)
        }
        .tint(AppColors.label)
        
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
