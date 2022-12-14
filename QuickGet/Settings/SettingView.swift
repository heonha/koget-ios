//
//  SettingView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/25.
//

import SwiftUI

struct SettingView: View {
    
    @State var isAlertPresent: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: AppColors.deepDarkGrey)
                    .ignoresSafeArea()
                List {
                    
                    NavigationLink {
                        NoticeList()
                    } label: {
                        SettingButtonLabel(title: "공지사항", symbolName: "mic.fill")
                    }
                    
                    NavigationLink {

                    } label: {
                        SettingButtonLabel(title: "기능추가 요청하기", symbolName: "paperplane.fill")
                    }
                    .disabled(true)
                    
                    NavigationLink {

                    } label: {
                        SettingButtonLabel(title: "커피 한 잔 후원", symbolName: "cup.and.saucer.fill")
                    }
                    .disabled(true)
                    
                    NavigationLink {

                    } label: {
                        SettingButtonLabel(title: "오픈소스 라이선스", symbolName: "chart.bar.doc.horizontal")
                    }
                    .disabled(true)
                    
                }
                .alert("미구현", isPresented: $isAlertPresent, actions: {
                    
                })
                .padding(.top, 4)
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.large)

            }

        }
        .tint(Color.init(uiColor: AppColors.deepPurple))

    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct SettingButtonLabel: View {
    
    var title: LocalizedStringKey
    var symbolName: String
    
    var body: some View {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: symbolName)
                    .renderingMode(.template)
            }.tint(.white)
    }
}
