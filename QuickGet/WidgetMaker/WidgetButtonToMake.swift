//
//  CreateWidgetButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

// 위젯 만들기 버튼
struct WidgetButtonToMake: View {
    
    var size: CGSize = .init(width: DEVICE_SIZE.width - 50, height: 70)
    var backgroundColor: Color = Color.init(uiColor: .secondarySystemFill)
    
    @State private var isPresent: Bool = false
    
    var body: some View {
        VStack {
            NavigationLink {
                MakeWidgetView()
            } label: {
                
                // 버튼 Contents
                HStack {
                    Image(systemName: "cursorarrow.and.square.on.square.dashed")
                        .font(.system(size: 40))
                        .foregroundColor(.init(uiColor: .label))
                    Spacer()
                    
                    Text("위젯 만들기")
                        .foregroundColor(.init(uiColor: .label))
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding()
                .background(backgroundColor)
            }
            .frame(width: size.width , height: size.height)
            .cornerRadius(10)
            .padding()
        }
        
    }
}
struct CreateWidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        WidgetButtonToMake()
    }
}
