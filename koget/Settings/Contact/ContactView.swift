//
//  ContactView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/08.
//

import SwiftUI

struct ContactView: View {
    
    
    @State var titleText: String = ""
    @State var bodyText: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("문의 제목")
                    .font(.system(size: 18, weight: .bold))
                TextFieldView(placeholder: "문의 제목", type: .title, text: $titleText)

                Divider()
                CustomTextEditor(placeHolder: "이곳에 문의내용을 입력하세요.", text: $bodyText)
            }
            .padding(8)
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
