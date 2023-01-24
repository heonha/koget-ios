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
        VStack(alignment: .leading, spacing: 4) {
            // 타이틀
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .lineLimit(1)
            if isEditingMode {
                // 편집 모드
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(AppColors.secondaryBackgroundColor)
            } else {
                // 뷰어 모드
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .background(AppColors.backgroundColor)
                    .disabled(!isEditingMode)
            }
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .cornerRadius(8)
        .padding(.horizontal, 16)

    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
                
        DetailWidgetView(selectedWidget: DeepLink.example)
        
    }
}
