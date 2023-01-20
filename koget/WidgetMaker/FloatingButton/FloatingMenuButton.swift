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
    var size = CGSize(width: 140, height: 50)
    
    // content
    var textInfo: (color: Color, fontSize: CGFloat, weight: Font.Weight)
        = (color: .black, fontSize: 18, weight: .medium)
    
    // view
    var borderColor = Color(hex: "F4F4F4")
    var backgroundColor = Color.white
    var shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
        = (color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
    
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
                            .font(.system(size: textInfo.fontSize))
                            .foregroundStyle(symbolColor)
                        
                        Spacer()
                        Text(text)
                            .lineLimit(1)
                            .font(.system(size: textInfo.fontSize, weight: textInfo.weight))
                            .foregroundStyle(textInfo.color)
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: size.width, height: size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
                    
                }

                
            case .sheet:
                Button {
                    self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                        FloatingDestinationView(type: link)
                    })
                } label: {
                    HStack {
                        Image(systemName: systemName)
                            .font(.system(size: textInfo.fontSize))
                            .foregroundStyle(symbolColor)
                        
                        Spacer()
                        Text(text)
                            .lineLimit(1)
                            .font(.system(size: textInfo.fontSize, weight: textInfo.weight))
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: size.width, height: size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)

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
