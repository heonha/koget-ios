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
            ZStack {
                AppColors.deepDarkGrey
                    .ignoresSafeArea()
                List {
                    
                    Section("설정") {
                        NavigationLink {
                            NoticeList()
                        } label: {
                            SettingButtonLabel(title: "공지사항", symbolName: "mic.fill")
                        }
                        
                        NavigationLink {
                            ContactView()
                        } label: {
                            SettingButtonLabel(title: "개발자에 문의하기", symbolName: "paperplane.fill")
                        }
                        
                        NavigationLink {
                            
                        } label: {
                            SettingButtonLabel(title: "커피 한 잔 후원", symbolName: "cup.and.saucer.fill")
                        }
                        .disabled(true)
                        
                        // NavigationLink {
                        //
                        // } label: {
                        //     SettingButtonLabel(title: "오픈소스 라이선스", symbolName: "chart.bar.doc.horizontal")
                        // }
                        // .disabled(true)
                        
                    }
                    
                    
                    Section("앱 정보") {
                        HStack {
                            Text("코코아젯 버전")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                                .bold()
                        }
                    }
                    
                }
                .tint(.white)
                .alert("미구현", isPresented: $isAlertPresent, actions: {
                    
                })
                .padding(.top, 4)
                .navigationTitle("코코아 젯")
                .navigationBarTitleDisplayMode(.large)
            }
            .foregroundColor(.white)

    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
