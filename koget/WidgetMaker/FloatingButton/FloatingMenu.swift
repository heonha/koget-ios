//
//  FloatingMenu.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/14.
//

import SwiftUI
import FloatingButton

struct FloatingMenu: View {
    
    enum ButtonFocus {
        case mainButton
        case subButton
    }
    
    @Binding var isOpen: Bool
    var buttons: [FloatingMenuButton]
    let mainButton = FloatingMainButton()
    
    var body: some View {
        
        FloatingButton(mainButtonView: mainButton, buttons: buttons, isOpen: $isOpen)
            .straight()
            .animation(.easeInOut(duration: 0.3))
            .direction(.top)
            .alignment(.right)
            .initialOpacity(0)
            .delays(delayDelta: 0.05)
            .padding(16)
            
        
    }
}

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu(isOpen: .constant(false), buttons: [
            FloatingMenuButton(systemName: "gearshape.fill", text: "설정", link: .aboutApp, type: .navigationLink),
            FloatingMenuButton(systemName: "plus.circle.fill", text: "만들기", link: .add, type: .sheet)
        ])    }
}


