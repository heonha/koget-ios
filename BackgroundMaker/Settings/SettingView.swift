//
//  SettingView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: AppColors.deepDarkGrey)
                    .ignoresSafeArea()
                List {
                    Button {
                        
                    } label: {
                        HStack {
                            Text("공지사항")
                            Spacer()
                            Image(systemName: "mic.fill")
                                .renderingMode(.template)
                        }
    
                    }.tint(.white)
                    

                    Button {
                        
                    } label: {
                        HStack {
                            Text("개발자에게 문의하기")
                            Spacer()
                            Image(systemName: "paperplane.fill")
                                .renderingMode(.template)
                        }
    
                    }.tint(.white)
                    Button {
                        
                    } label: {
                        HStack {
                            Text("커피 한 잔 후원")
                            Spacer()
                            Image(systemName: "cup.and.saucer.fill")
                                .renderingMode(.template)
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Text("오픈소스 라이선스")
                            Spacer()
                            Image(systemName: "chart.bar.doc.horizontal")
                                .renderingMode(.template)
                        }
    
                    }.tint(.white)

                }
                .padding(.top, 4)
                .navigationTitle("설정")
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
