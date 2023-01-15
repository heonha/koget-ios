//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

struct NewFloatingButton: View {
    
    var size: CGFloat = 50
    var color: Color = AppColors.buttonMainColor
    
    var body: some View {
        
        HStack {
            Spacer().layoutPriority(10)
            VStack {
                Spacer().layoutPriority(10)
                FloatingMenu()
                    .padding(16)
            }
        }
        .padding()
        .tint(.white)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        NewFloatingButton()
    }
}
