//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

struct FloatingButton: View {
    
    var size: CGFloat = 50
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                Spacer()
                
                NavigationLink {
                    SettingView()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: size, height: size)
                            .foregroundColor(AppColors.choco)
                        Image(systemName: "ellipsis")
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
