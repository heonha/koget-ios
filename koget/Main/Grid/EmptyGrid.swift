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
                VStack(spacing: 8) {
                    
                    Text("🤔")
                        .font(.system(size: 50))
                        .padding(.horizontal, 16)
                    Text("아직 생성한 위젯이 없어요,")
                    Text("첫번째 바로가기 위젯을 생성해보세요!")
                }
                .padding(.bottom, 32)
                
                NavigationLink {
                    MakeWidgetView()
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(Constants.kogetGradient)
                        
                        Text("첫번째 바로가기 위젯 만들기")
                            .font(.system(size: 18, weight: .semibold))
                            .padding()
                    }
                }
                .frame(width: DEVICE_SIZE.width - 32, height: 40)
            }
        }
        .frame(width: DEVICE_SIZE.width - 32, height: DEVICE_SIZE.height / 1.5)
    }
}

struct EmptyGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmptyGrid()
    }
}
