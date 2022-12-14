//
//  CreateWidgetButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

// 위젯 만들기 버튼
struct WidgetButtonToMake: View {
    
    @State private var isPresent: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                NavigationLink {
                    MakeWidgetView()
                } label: {
                    HStack {
                        Image(systemName: "cursorarrow.and.square.on.square.dashed")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .tint(.gray)
                        Spacer()
                        
                        Text("위젯 만들기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    .padding()
                    .background(Color(uiColor: AppColors.normalDarkGrey))
                    .shadow(radius: 3)
                }
                .frame(width: Constants.deviceSize.width - 50, height: 70)
                .background(Color(uiColor: AppColors.deepDarkGrey))
                .cornerRadius(10)
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        
    }
}
struct CreateWidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        WidgetButtonToMake()
    }
}
