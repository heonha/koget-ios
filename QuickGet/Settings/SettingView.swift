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
                Section("일반") {
                    NavigationLink {
                        NoticeList()
                    } label: {
                        SettingButtonLabel(title: "공지사항 (미구현)", symbolName: "mic.fill")
                    }
                    
                    NavigationLink {
                        ContactView()
                    } label: {
                        SettingButtonLabel(title: "개발자에 문의하기 (미구현)", symbolName: "paperplane.fill")
                    }
                }
            
                Section("기타") {
                    
                    Button {
                        
                    } label: {
                        SettingButtonLabel(title: "커피 한 잔 후원 (미구현)", symbolName: "cup.and.saucer.fill")
                    }
                    
                    HStack {
                        Text("코코아젯 버전")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                            .bold()
                    }
                    .foregroundColor(.gray)

                    

                    
                Button {
                    
                } label: {
                    SettingButtonLabel(title: "앱 초기화 (미구현)", symbolName: "exclamationmark.triangle.fill", color: AppColors.destroy)
                }
                    
            }
            
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
