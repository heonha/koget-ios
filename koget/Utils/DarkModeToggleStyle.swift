//
//  MyToggleStyle.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/08.
//

import SwiftUI
import SFSafeSymbols

struct DarkModeToggleStyle: ToggleStyle {

    let toggleSize = CGSize(width: 28, height: 28)
    let darkBGColor = Color.purple
    let lightBGColor = Color.yellow

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Circle()
                .foregroundColor(configuration.isOn ? AppColor.darkGray : AppColor.Background.first)
                .frame(width: toggleSize.width, height: toggleSize.height, alignment: .center)
                .overlay(
                    ZStack(content: {
                        Image(systemSymbol: configuration.isOn ? .moonFill : .sunMaxFill)
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(.yellow)
                            .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.35), radius: 0.5, x: 0.5, y: 1)
                            .padding(2)

                    })

                )
                .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.1), radius: 0.5, x: 0, y: 0)
                .animation(.linear(duration: 0.2), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
//
// struct ToggleTester: View {
//     @StateObject var constatnt = Constants.shared
//     var body: some View {
//         HStack {
//             Toggle(isOn: $constatnt.isDarkMode) {
//             }
//             .toggleStyle(DarkModeToggleStyle())
//             Spacer()
//         }
//     }
// }
// 
// struct DarkModeToggleStyle_Previews: PreviewProvider {
// 
//     static var previews: some View {
//         ToggleTester()
//     }
// }
