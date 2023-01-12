//
//  HelpView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/12.
//

import SwiftUI

struct HelpView: View {
    
    @Binding var isPresentHelper: Bool
    
    var body: some View {
        if isPresentHelper {
            Color.black
                .ignoresSafeArea()
                .opacity(0.4)
            FloatingButton()
                .disabled(true)
        }
    }
    
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(isPresentHelper: .constant(true))
    }
}
