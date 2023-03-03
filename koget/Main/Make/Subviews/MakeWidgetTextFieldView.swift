//
//  MakeWidgetTextFieldView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

enum FocusFields {
    case name, url
}

struct MakeWidgetTextFieldView: View {
    
    @ObservedObject var viewModel: MakeWidgetViewModel
    
    let nameTitle: LocalizedStringKey = "위젯 이름"
    let namePlaceholder: LocalizedStringKey = "위젯 이름을 입력하세요."
    
    let urlTitle: LocalizedStringKey = "URL"
    let urlPlaceholder: LocalizedStringKey = "앱주소:// 또는 https://웹주소"
    
    var body: some View {
        VStack {
            CustomTextfield(title: nameTitle, placeholder: namePlaceholder, text: $viewModel.name, viewModel: viewModel, equals: .name)
            
            ZStack {
                CustomTextfield(title: urlTitle, placeholder: urlPlaceholder, text: $viewModel.url, viewModel: viewModel, equals: .url)
                if viewModel.url != "" {
                    URLTestButton(viewModel: viewModel)
                        .padding(.trailing)
                        .padding(.bottom, 48)
                }
            }
        }
    }
}

struct MakeWidgetTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MakeWidgetTextFieldView(viewModel: MakeWidgetViewModel())
    }
}
