//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

struct FloatingButton: View {
    
    var size: CGFloat = 50
    var color: Color = AppColors.buttonMainColor
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                Spacer()
                
                NavigationLink {
                    MakeWidgetView()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: size, height: size)
                            .foregroundColor(color)
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .tint(.white)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}
