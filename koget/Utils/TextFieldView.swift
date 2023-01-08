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
    
    let placeholder: String
    let padding: CGFloat = 32
    
    var type: TextFieldType = .title
    
    @Binding var text: String
    
    var body: some View {

        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 40)
                .foregroundColor(AppColors.secondaryBackgroundColor)
            
            TextField(placeholder, text: $text)
                .background(Color.clear)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textCase(.none)
                .padding(.horizontal,8)
            
        }
            

    }
}


struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldView(placeholder: "제목을 입력하세요.", text: .constant(""))
            TextFieldView(placeholder: "내용을 입력하세요.", type: .body, text: .constant(""))
        }
    }
}
