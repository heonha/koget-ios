//
//  EditTextField.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import SFSafeSymbols

protocol VMTextFieldProtocol: ObservableObject {
    var nameStringLimit: Int { get set }
    var nameMaxCountError: Bool { get set }
    var nameMaxCountErrorMessage: String { get set }
    var isEditingMode: Bool { get set }
}

struct EditTextField<V: VMTextFieldProtocol>: View {

    let systemSymbol: SFSymbol
    let placeHolder: String
    // let padding: CGFloat = 32
    @State var trailingPadding: CGFloat?
    @ObservedObject var viewModel: V
    @Binding var text: String

    @ObservedObject var constant = AppStateConstant.shared
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                // 타이틀
                Image(systemSymbol: systemSymbol)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColor.Label.second)
                    .frame(width: 40)
                
                    TextField(placeHolder, text: $text)
                        .font(.custom(.robotoMedium, size: 16))
                        .modifier(BaseModifierForTextField())
                        .background(viewModel.isEditingMode ? .regularMaterial : .ultraThinMaterial)
                        .disabled(viewModel.isEditingMode ? false : true)

            }
            .cornerRadius(8)
            if systemSymbol == .tag && viewModel.nameMaxCountError == true {
                    withAnimation {
                        Text(viewModel.nameMaxCountErrorMessage)
                            .foregroundColor(.red)
                            .font(.custom(.robotoLight, size: 12))
                    }
            }
        }
        .frame(height: 40)

    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
                
        DetailWidgetView(selectedWidget: DeepLink.example)
            .environmentObject(HomeWidgetViewModel())
        
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


struct BaseModifierForTextField: ViewModifier {
    
    func body(content: Content) -> some View {
        
        ZStack {
            content
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textCase(.none)
                .frame(height: 35)
                .padding(.trailing)
                .background(.clear)
        }
        .padding(.horizontal)
        .cornerRadius(5)
     
    }
}
