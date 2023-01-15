//
//  FloatingMenu.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/14.
//

import SwiftUI
import FloatingButton

struct FloatingMenu: View {
    
    @State var isOpen: Bool = false
    
    var body: some View {
        let mainButton = FloatingMainButton()
        let buttons = [
            FloatingMenuButton(systemName: "gearshape.fill", text: "설정", link: .setting),
            FloatingMenuButton(systemName: "plus.circle.fill", text: "만들기", link: .add, symbolColor: Color(hex: "C21010"))
        ]
        
        FloatingButton(mainButtonView: mainButton, buttons: buttons, isOpen: $isOpen)
            .straight()
            .animation(.easeInOut(duration: 0.3))
            .direction(.top)
            .alignment(.right)
            .initialOpacity(0)
            .delays(delayDelta: 0.05)
        
    }
}

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu()
    }
}


