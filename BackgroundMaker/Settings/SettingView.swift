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
                    ButtonForSetting(title: "공지사항", symbolName: "mic.fill") {
                        isAlertPresent.toggle()
                    }
                    ButtonForSetting(title: "개발자에게 문의하기", symbolName: "paperplane.fill") {
                        isAlertPresent.toggle()
                    }
                    ButtonForSetting(title: "커피 한 잔 후원", symbolName: "cup.and.saucer.fill") {
                        isAlertPresent.toggle()
                    }
                    ButtonForSetting(title: "오픈소스 라이선스", symbolName: "chart.bar.doc.horizontal") {
                        isAlertPresent.toggle()
                    }
                }
                .alert("미구현", isPresented: $isAlertPresent, actions: {
                    
                })
                .padding(.top, 4)
                .navigationTitle("설정(미구현)")
                .navigationBarTitleDisplayMode(.large)

            }

        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct ButtonForSetting: View {
    
    var title: LocalizedStringKey
    var symbolName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: symbolName)
                    .renderingMode(.template)
            }
            
        }.tint(.white)
    }
}
