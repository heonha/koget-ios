//
//  EmptyGrid.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/10.
//

import SwiftUI

struct EmptyGrid: View {
    var body: some View {
        ZStack {
            VStack {

                
                NavigationLink {
                    MakeWidgetView()
                    
                } label: {
                    VStack(spacing: 8) {

                        Text("이곳을 눌러 바로가기 위젯을 생성하고")
                            .font(.custom(CustomFont.NotoSansKR.bold, size: 16))
                        Text("다양한 앱/웹페이지에 빠르게 접근하세요!")
                            .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
                            .foregroundStyle(Constants.kogetGradient)
                    }
                    .padding(.bottom, 32)
                }
                .frame(width: deviceSize.width - 32, height: 40)

            }
        }
    }
}

struct EmptyGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmptyGrid()
    }
}
