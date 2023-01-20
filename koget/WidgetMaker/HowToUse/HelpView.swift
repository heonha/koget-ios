//
//  HelpView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/19.
//

import SwiftUI

struct HowToUseLinkWidget: View {
    var body: some View {
        ZStack {
            Color.white
            
            VStack(spacing: 16) {
                List{
                    Text("위젯을 사용하는 방법")
                    Text("위젯을 추가하는 방법")
                }
            }

        }
        .frame(width: 300, height: 400)
        .cornerRadius(8)
        .clipped()
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseLinkWidget()
    }
}
