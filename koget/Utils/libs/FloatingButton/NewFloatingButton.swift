//
//  FloatingButton.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI
import SFSafeSymbols

struct NewFloatingButton: View {
    
    var size: CGFloat = 50
    var color: Color = AppColor.buttonMainColor
    @Binding var isOpen: Bool
    
    var body: some View {
        
        HStack {
            Spacer().layoutPriority(10)
            VStack {
                Spacer().layoutPriority(10)
                FloatingMenu(isOpen: $isOpen,
                             buttons: [
                                FloatingMenuButton(systemName: .plusCircleFill, text: "위젯 만들기", link: .add,  type: .navigationLink),
                             ].reversed())
                .opacity(0.95)
            }
        }
        .padding()
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        NewFloatingButton(isOpen: .constant(false))
    }
}
