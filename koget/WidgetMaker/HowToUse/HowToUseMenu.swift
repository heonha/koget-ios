//
//  HowToUseMenu.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/19.
//

import SwiftUI

struct HowToUseMenu: View {
    
    @State var isHelperPresent: Bool = false
    
    var body: some View {
        Menu {
            Button(action: {
                isHelperPresent.toggle()
            }) {
                Label("위젯 사용 방법", systemImage: "squere")
            }
        } label: {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 24, weight: .semibold))
                .background(Color.init(uiColor: .secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
                .clipShape(Circle())
        }
    }
}

struct HowToUseMenu_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseMenu()
    }
}
