//
//  WidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/04.
//

import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct WidgetView: View {
    
    @State private var username: String = ""
    // @FocusState private var emailFieldIsFocused: Bool = false
    
    var body: some View {
        VStack {
            Text("딥 링크 주소")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(4)
            // TextField(
            //     "딥 링크 주소 입력( 예시: youtube:// )",
            //     text: $username
            // )
            // .textInputAutocapitalization(.never)
            // .disableAutocorrection(true)
            // .border(.secondary)
            // .cornerRadius(5)
            // .padding(20)
            // .frame(width: 300, height: 50, alignment: .leading)
            // Button() {
            //     //
            // } label: {
            //     Text("만들기")
            // }.padding(8).backgroundStyle(.white)

        }
        
    }
}

@available(iOS 16.0, *)
struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
