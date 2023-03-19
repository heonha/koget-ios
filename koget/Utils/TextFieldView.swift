//
//  TextFieldView.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI
import SFSafeSymbols

enum TextFieldType {
    case title
    case body
}

struct TextFieldView: View {
    
    var systemName: SFSymbol?
    let placeholder: String
    let padding: CGFloat = 32
    
    var type: TextFieldType = .title
    
    @Binding var text: String
    
    var body: some View {

        ZStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 40)
                .foregroundColor(AppColor.Background.second)
            ZStack(alignment: .leading) {
                HStack {

                if let systemName = systemName {
                    Image(systemSymbol: systemName)
                        .font(.system(size: 15))
                        .padding(.horizontal, 8)
                        .foregroundColor(.gray)
                    TextField(placeholder, text: $text)
                        .foregroundColor(AppColor.Label.first)
                        .background(AppColor.Background.second)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                        .padding(.leading, -12)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(AppColor.Label.first)
                        .background(AppColor.Background.second)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                        .padding(.horizontal,8)
                }
                    Spacer()

                }

            }
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldView(systemName: .magnifyingglass, placeholder: S.WidgetAssetList.searchApp, text: .constant(""))
            TextFieldView(placeholder: "내용을 입력하세요.", type: .body, text: .constant(""))
        }
    }
}
