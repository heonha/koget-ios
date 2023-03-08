//
//  CustomTextEditor.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct CustomTextEditor: View {
    var placeHolder: LocalizedStringKey
    @Binding var text: String
    
    var body: some View {
        ZStack {
            AppColor.Background.first
            TextEditor(text: $text)
                .foregroundColor(AppColor.Label.first)
                .colorMultiply(AppColor.Background.third)
                .padding(4)
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(placeHolder)
                            .padding(.leading, 8)
                            .padding(.top, 12)
                            .foregroundColor(.init(uiColor: .tertiaryLabel))
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .cornerRadius(5)
    }
}

struct CustomTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEditor(placeHolder: "플레이스홀더", text: .constant(""))
    }
}
