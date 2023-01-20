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
    case help
}

enum FloatingMenuType {
    case navigationLink
    case sheet
}

struct FloatingMenuButton: View {
    
    var systemName: String
    var text: String
    var link: NavigationLinkType
    var type: FloatingMenuType
    var symbolColor = LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
    @State var isPresent = false
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        ZStack {
            
            switch type {
            case .navigationLink:
                NavigationLink {
                    FloatingDestinationView(type: link)
                } label: {
                    HStack {
                        Image(systemName: systemName)
                            .foregroundStyle(symbolColor)
                        
                        Spacer()
                        Text(text)
                            .lineLimit(1)
                            .foregroundStyle(Color.black)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: 120, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
                        
                    )
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)

                    
                    
                }

                
            case .sheet:
                Button {
                    self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                        FloatingDestinationView(type: link)
                    })
                } label: {
                    HStack {
                        Image(systemName: systemName)
                            .foregroundStyle(symbolColor)
                        
                        Spacer()
                        Text(text)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: 120, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
                        
                    )
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                    
                }
                
            }
            
        }
    }
}
struct FloatingMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenuButton(systemName: "person.fill", text: "텍스트", link: .setting, type: .navigationLink)
    }
}
