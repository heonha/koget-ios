//
//  EditTextField.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct EditTextField: View {
    
    let title: String
    let placeHolder: String
    let padding: CGFloat = 32
    
    @Binding var isEditingMode: Bool
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 18))
                .lineLimit(1)
                .frame(height: 40)
                .padding(.horizontal, 16)
                .padding(.bottom, -12)
            if isEditingMode {
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(Color.init(uiColor: .darkGray))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .disabled(!isEditingMode)
            } else {
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(Color.init(uiColor: AppColors.blackDarkGrey))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .disabled(!isEditingMode)
            }
            
        }
    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
                
        EditTextField(title: "제목",
                      placeHolder: "placeHolder",
                      isEditingMode: .constant(false),
                      text: .constant("")
        )
    }
}
