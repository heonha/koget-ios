//
//  FloatingMainButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/15.
//

import SwiftUI


struct FloatingMainButton: View {
    
    var buttonSize: CGFloat = 50
    var imageSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            Color.gray
                .clipShape(Circle())
            Image(systemName: "line.3.horizontal")
                .font(.system(size: imageSize, weight: .medium))
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
                .foregroundColor(Color.init(uiColor: .white))
                .shadow(color: .black, radius: 0.3, x: 0.25, y: 0.25)
            
        }
        .frame(width: buttonSize, height: buttonSize)
        
    }
}


struct FloatingMainButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMainButton()
    }
}
