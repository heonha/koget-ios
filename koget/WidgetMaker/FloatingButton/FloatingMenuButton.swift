//
//  FloatingMenuButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/15.
//

import SwiftUI

enum NavigationLinkType {
    case add
    case setting
}

struct FloatingMenuButton: View {
    
    var systemName: String
    var text: String
    var link: NavigationLinkType
    var symbolColor: Color = Color.gray
    
    var body: some View {
        ZStack {
            NavigationLink {
                FloatingDestinationView(type: link)
            } label: {
                HStack {
                    Image(systemName: systemName)
                        .foregroundColor(symbolColor)

                    Spacer()
                    Text(text)
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(8)
                .frame(width: 120, height: 45)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
                )
            }
        }
    }
}
struct FloatingMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenuButton(systemName: "person.fill", text: "텍스트", link: .setting)
    }
}
