//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI
import SFSafeSymbols

struct MainFloatingButton: View {
    
    var size: CGFloat = 50
    @Binding var isOpen: Bool
    
    var body: some View {
        
        FloatingMenu(isOpen: $isOpen,
                     buttons: [
                        FloatingMenuButton(systemName: .plusCircleFill, text: S.FloatingButton.makeWidget, link: .add,  type: .navigationLink),
                     ].reversed())
        .opacity(0.95)

    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        MainFloatingButton(isOpen: .constant(false))
    }
}
