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
    @Binding var isOpen: Bool
    
    var body: some View {
        
        HStack {
            Spacer().layoutPriority(10)
            VStack {
                Spacer().layoutPriority(10)
                FloatingMenu(isOpen: $isOpen,
                             buttons: [
                                FloatingMenuButton(systemName: "plus.circle.fill", text: "위젯 만들기", link: .add,  type: .navigationLink),
                                FloatingMenuButton(systemName: "line.3.horizontal.circle", text: "위젯 편집", link: .edit,  type: .navigationLink),
                                FloatingMenuButton(systemName: "mail", text: "문의하기", link: .contact,  type: .navigationLink),
                             ].reversed())
                .opacity(0.95)
            }
        }
        .padding()
        .tint(.white)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        NewFloatingButton(isOpen: .constant(false))
    }
}
