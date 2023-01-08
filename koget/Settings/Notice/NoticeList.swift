//
//  NoticeList.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/12/01.
//

import SwiftUI

struct NoticeList: View {
    
    
    var titleColor: Color = AppColors.label
    
    @State var isPresent: Bool = false
    
    var body: some View {
        
        List {
            Button {
                isPresent.toggle()
            } label: {
                HStack {
                    Text("새로운 딥 링크 앱이 추가되었습니다.")
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .foregroundColor(titleColor)
                    Spacer()
                    Text("22-12-01")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                

            }
            .sheet(isPresented: $isPresent) {
                NoticeContentView()
            }
            
            Button {
                isPresent.toggle()
            } label: {
                HStack {
                    Text("앱이 출시되었습니다.")
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .foregroundColor(titleColor)
                    Spacer()
                    Text("22-11-30")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                

            }
            .sheet(isPresented: $isPresent) {
                NoticeContentView()
            }
            
            
        }
        .navigationTitle("공지사항")
    }
}

struct NoticeList_Previews: PreviewProvider {
    static var previews: some View {
        NoticeList()
    }
}


