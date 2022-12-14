//
//  DetailWidgetButton.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct DetailWidgetButton: View {
    
    var text: AttributedString
    var buttonColor: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 17))
                .frame(width: 200, height: 30)
        }
        .background(buttonColor)
        .cornerRadius(8)
    }
}

struct DetailWidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        DetailWidgetButton(text: "닫기", buttonColor: .init(uiColor: .darkGray)) {
        }
    }
}
