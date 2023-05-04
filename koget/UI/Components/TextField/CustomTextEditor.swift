//
//  CustomTextEditor.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct CustomTextEditor: View {
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        ZStack {
            AppColor.Background.second
            TextEditor(text: $text)
                .foregroundColor(AppColor.Label.first)
                .scrollContentBackground(.hidden) // <- Hide it
                .padding(4)
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(placeHolder)
                            .padding(.leading, 8)
                            .padding(.top, 12)
                            .foregroundColor(AppColor.Label.third)
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
        NavigationView {
            ContactView()
        }
    }
}
