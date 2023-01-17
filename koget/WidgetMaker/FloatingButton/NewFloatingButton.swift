//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

struct NewFloatingButton: View {
    
    var size: CGFloat = 50
    var color: Color = AppColors.buttonMainColor
    @State var isOpen: Bool = false
    
    var body: some View {
        
        HStack {
            Spacer().layoutPriority(10)
            VStack {
                Spacer().layoutPriority(10)
                FloatingMenu(isOpen: $isOpen,
                             buttons: [
                                FloatingMenuButton(systemName: "gearshape.fill", text: "설정", link: .setting),
                                FloatingMenuButton(systemName: "plus.circle.fill", text: "만들기", link: .add, symbolColor: Color(hex: "C21010"))
                             ])
            }
        }
        .padding()
        .tint(.white)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        NewFloatingButton()
    }
}
