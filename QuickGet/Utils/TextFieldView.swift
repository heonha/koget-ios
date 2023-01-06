//
//  TextFieldView.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

enum TextFieldType {
    case title
    case body
}

struct TextFieldView: View {
    
    let placeHolder: String
    let padding: CGFloat = 32
    
    var type: TextFieldType = .title
    
    @Binding var text: String
    
    var body: some View {

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: type == .title ? 40 : 300)
                    .foregroundColor(AppColors.secondaryBackgroundColor)
                TextField(placeHolder, text: $text)
                    .background(Color.clear)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textCase(.none)
                    .padding(8)
            }
            

    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldView(placeHolder: "제목을 입력하세요.", text: .constant(""))
            TextFieldView(placeHolder: "내용을 입력하세요.", type: .body, text: .constant(""))
        }
    }
}
