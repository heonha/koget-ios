//
//  FloatingMainButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/15.
//

import SwiftUI

struct FloatingMainButton: View {

    @EnvironmentObject var constant: Constants

    var buttonSize: CGFloat = 50
    var imageSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(Circle())
                .opacity(constant.isDarkMode ? 0.9 : 1.0)

            Image(systemName: "line.3.horizontal")
                .font(.system(size: imageSize, weight: .medium))
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
                .foregroundColor(Color.init(uiColor: .white))
                .padding()
        }
        .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
        .frame(width: buttonSize, height: buttonSize)
    }
}

struct FloatingMainButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMainButton()
    }
}
