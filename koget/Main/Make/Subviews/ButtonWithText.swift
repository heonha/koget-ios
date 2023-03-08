//
//  ButtonWithText.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2023/01/01.
//

import SwiftUI

struct ButtonWithText: View {
    
    var title: LocalizedStringKey
    var titleColor: Color = AppColor.Label.first
    let font: Font = .system(size: 18, weight: .semibold)
    let buttonHeight: CGFloat = 40
    var color: Color = .init(uiColor: .systemFill)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: buttonHeight)
                .foregroundColor(color)
                .clipped()
            Text(title)
                .foregroundColor(titleColor)
                .font(font)
        }
        .cornerRadius(5)
    }
}
struct ButtonWithText_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithText(title: "버튼타이틀")
    }
}
