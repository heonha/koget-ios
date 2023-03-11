//
//  FloatingMenuButton.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/15.
//

import SwiftUI
import SFSafeSymbols

enum NavigationLinkType {
    case add
    case aboutApp
    case contact
    case edit

}

enum FloatingMenuType {
    case navigationLink
    case sheet
}

struct FloatingMenuButton: View {
    var systemName: SFSymbol
    var text: LocalizedStringKey
    var link: NavigationLinkType
    var type: FloatingMenuType
    var symbolColor = LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
    var size = CGSize(width: 140, height: 50)
    // content
    var textInfo: (color: Color, fontSize: CGFloat, weight: Font.Weight)
    = (color: Color.init(uiColor: .label), fontSize: 15, weight: .medium)
    // view
    var borderColor = AppColor.Background.third
    @EnvironmentObject var constant: Constants

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
                        Image(systemSymbol: systemName)
                            .font(.system(size: textInfo.fontSize))
                            .foregroundStyle(symbolColor)
                        
                        Spacer()
                        Text(text)
                            .lineLimit(1)
                            .font(.system(size: textInfo.fontSize, weight: textInfo.weight))
                            .lineLimit(2, reservesSpace: false)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(textInfo.color)
                        Spacer()
                    }
                    .padding(8)
                    .frame(width: size.width, height: size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .background(constant.isDarkMode ? AppColor.Background.second : AppColor.Background.first)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                }

            case .sheet:
                Button {
                    self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve, builder: {
                        FloatingDestinationView(type: link)
                    })
                } label: {
                    HStack {
                        Image(systemSymbol: systemName)
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
                    .background(constant.isDarkMode ? AppColor.Background.second : AppColor.Background.first)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)

                }
                
            }
            
        }

    }
}
struct FloatingMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenuButton(systemName: .personFill, text: "텍스트", link: .aboutApp, type: .navigationLink)
    }
}
