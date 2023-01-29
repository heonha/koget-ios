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
    
    let nameTitle = "위젯 이름"
    let namePlaceholder = "위젯 이름을 입력하세요."
    
    let urlTitle = "URL"
    let urlPlaceholder = "앱주소:// 또는 https://웹주소"
    
    var body: some View {
        VStack {
            CustomTextfield(title: nameTitle, placeholder: namePlaceholder, text: $viewModel.name, equals: .name, viewModel: viewModel)
            
            ZStack {
                CustomTextfield(title: urlTitle, placeholder: urlPlaceholder, text: $viewModel.url, equals: .url, viewModel: viewModel)
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
