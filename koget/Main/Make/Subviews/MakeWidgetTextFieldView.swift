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
    let namePlaceholder: LocalizedStringKey = "위젯 이름"
    
    let urlTitle: LocalizedStringKey = "URL"
    let urlPlaceholder: LocalizedStringKey = "앱 / 웹 주소 (특수문자 :// 포함)"
    
    var body: some View {
        VStack {
            CustomTextfield(title: nameTitle, placeholder: namePlaceholder, systemName: "tag", text: $viewModel.name, viewModel: viewModel, equals: .name)
            
            CustomTextfield(title: urlTitle, placeholder: urlPlaceholder, systemName: "link", text: $viewModel.url, viewModel: viewModel, equals: .url)
            if viewModel.url != "" {
                withAnimation {
                    HStack {
                        Spacer()
                        URLTestButton(viewModel: viewModel)
                            .padding(.trailing)
                    }
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
