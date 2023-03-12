//
//  DetailWidgetCancelButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct DetailWidgetCancelButton: View {
    
    var text: LocalizedStringKey
    var titleColor: Color = AppColor.Label.first
    var buttonColor: Color
    var size: CGSize = .init(width: 200, height: 35)
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(titleColor)
                .font(.system(size: 17, weight: .bold))
                .frame(width: size.width, height: size.height)
        }
        .background(buttonColor)
        .cornerRadius(8)
    }
}

struct DetailWidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        DetailWidgetCancelButton(text: "닫기", buttonColor: .init(uiColor: .darkGray)) {
        }
    }
}
