//
//  EditTextField.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import ToastUI

struct EditTextField: View {
    
    let title: LocalizedStringKey
    let placeHolder: LocalizedStringKey
    let padding: CGFloat = 32
    
    @StateObject var viewModel: DetailWidgetViewModel
    @Binding var isEditingMode: Bool
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 타이틀
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                Spacer()
                if title != "URL" && viewModel.nameMaxCountError == true {
                        withAnimation {
                            Text(viewModel.nameMaxCountErrorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                } 
            }
            if isEditingMode {
                // 편집 모드
                TextField(placeHolder, text: $text)
                    .frame(height: 35)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textCase(.none)
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
        

    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
                
        DetailWidgetView(selectedWidget: DeepLink.example)
        
    }
}
