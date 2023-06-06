//
//  TextMediumButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct TextButton: View {
    
    var title: String
    var titleColor: Color = AppColor.Label.first
    var backgroundColor: Color
    var size: (width: CGFloat?, height: CGFloat?) = (width: nil, height: 40)
    let font: Font = .custom(.robotoMedium, size: 18)
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(width: size.width, height: size.height)
                Text(title)
                    .foregroundColor(titleColor)
                    .font(font)
            }
        }
        .cornerRadius(8)

    }
}

struct DetailWidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(title: "타이틀", backgroundColor: AppColor.kogetBlue) {
            
        }
    }
}
