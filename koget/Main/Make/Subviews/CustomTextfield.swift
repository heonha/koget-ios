//
//  TextfieldWithTitle.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI
import SFSafeSymbols

enum Field: Hashable {
    case name
    case url
}

enum TextfieldType {
    case normal
    case widgetName
}

struct CustomTextfield: View {

    var title: LocalizedStringKey
    var placeholder: LocalizedStringKey
    var systemName: SFSymbol
    @Binding var text: String
    @StateObject var viewModel: MakeWidgetViewModel
    var equals: Field
    @FocusState var focusState: Field?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 식별 이미지 부분
                Image(systemSymbol: systemName)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 40, height: 40)
                    .foregroundColor(.init(uiColor: .lightGray))

                // 텍스트필드 부분
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 40)
                        .foregroundColor(AppColor.Background.second)
                    TextField(placeholder, text: $text)
                        .background(Color.clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textCase(.none)
                        .padding(.horizontal,8)
                        .focused($focusState, equals: equals)
                }
            }

            if equals == .name && viewModel.nameMaxCountError == true {
                withAnimation {
                    Text(viewModel.nameMaxCountErrorMessage)
                        .font(.custom(CustomFont.NotoSansKR.light, size: 14))
                        .foregroundColor(AppColor.Behavior.errorRed)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct TextfieldWithTitle_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextfield(title: "타이틀", placeholder: "플레이스홀더", systemName: .tag, text: .constant(""), viewModel: MakeWidgetViewModel(), equals: .name)
    }
}
