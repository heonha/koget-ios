//
//  ButtonWithText.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2023/01/01.
//

import SwiftUI

struct ButtonWithText: View {
    
    var title: String
    var titleColor: Color = AppColors.label
    let font: Font = .system(size: 18, weight: .semibold)
    let buttonSize: CGSize = .init(width: DEVICE_SIZE.width - 32, height: 40)
    var color: Color = .init(uiColor: .systemFill)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .foregroundColor(color)
                .clipped()
            Text(title)
                .foregroundColor(titleColor)
                .font(font)
        }
        .cornerRadius(5)
        .padding(.top, 8)
    }
}
struct ButtonWithText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithText(title: "버튼타이틀")
    }
}
