//
//  TextfieldWithTitle.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI
enum Field: Hashable {
    case name
    case url
}

struct CustomTextfield: View {
    
    var title: String
    var placeholder: String
    @Binding var text: String
    @FocusState var focusState: Field?
    var equals: Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
            
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
                    .focused($focusState, equals: equals)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct TextfieldWithTitle_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextfield(title: "타이틀", placeholder: "플레이스홀더", text: .constant(""), equals: .name)
    }
}
