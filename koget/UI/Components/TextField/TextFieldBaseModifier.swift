//
//  TextFieldModifier.swift
//  koget
//
//  Created by HeonJin Ha on 2023/07/02.
//

import SwiftUI

struct TextFieldBaseModifier: ViewModifier {
    
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
        .padding(.horizontal, 2)
        .cornerRadius(5)
     
    }
}
