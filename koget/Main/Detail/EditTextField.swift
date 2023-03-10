//
//  EditTextField.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import SFSafeSymbols

struct EditTextField: View {

    let systemSymbol: SFSymbol
    let placeHolder: LocalizedStringKey
    let padding: CGFloat = 32
    
    @StateObject var viewModel: DetailWidgetViewModel
    @ObservedObject var constant = Constants.shared
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                // 타이틀
                Image(systemSymbol: systemSymbol)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColor.Label.second)

                if viewModel.isEditingMode {
                    // 편집 모드
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(AppColor.Background.third)
                            .frame(height: 40)
                        TextField(placeHolder, text: $text)
                            .frame(height: 35)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .textCase(.none)
                            .padding(.horizontal, 4)
                            .background(.clear)
                    }
                } else {
                    // 뷰어 모드
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(AppColor.Background.second)
                            .frame(height: 40)
                        TextField(placeHolder, text: $text)
                            .frame(height: 35)
                            .background(.clear)
                            .padding(.horizontal, 4)
                            .disabled(true)
                    }
                }

            }
            .cornerRadius(8)
            .onTapGesture {
                hideKeyboard()
            }

            if systemSymbol == .tag && viewModel.nameMaxCountError == true {
                    withAnimation {
                        Text(viewModel.nameMaxCountErrorMessage)
                            .foregroundColor(.red)
                            .font(.custom(CustomFont.NotoSansKR.light, size: 12))
                    }
            }
        }
        
    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
                
        DetailWidgetView(selectedWidget: DeepLink.example)
        
    }
}

//
// VStack(alignment: .leading, spacing: 8) {
//     HStack {
//         // 식별 이미지 부분
//         Image(systemSymbol: systemName)
//             .font(.system(size: 20, weight: .bold))
//             .frame(width: 40, height: 40)
//             .foregroundColor(.init(uiColor: .lightGray))
//
//         // 텍스트필드 부분
//         ZStack(alignment: .center) {
//             RoundedRectangle(cornerRadius: 5)
//                 .frame(height: 40)
//                 .foregroundColor(AppColor.Background.second)
//             TextField(placeholder, text: $text)
//                 .background(Color.clear)
//                 .autocorrectionDisabled()
//                 .textInputAutocapitalization(.never)
//                 .textCase(.none)
//                 .padding(.horizontal,8)
//                 .focused($focusState, equals: equals)
//         }
//     }
//
//     if equals == .name && viewModel.nameMaxCountError == true {
//         withAnimation {
//             Text(viewModel.nameMaxCountErrorMessage)
//                 .font(.custom(CustomFont.NotoSansKR.light, size: 14))
//                 .foregroundColor(AppColor.Behavior.errorRed)
//         }
//     }
// }
