//
//  MyToggleStyle.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/08.
//

import SwiftUI
import SFSafeSymbols

struct DarkModeToggleStyle: ToggleStyle {

    let toggleSize = CGSize(width: 32, height: 32)
    let onBGColor = AppColor.Fill.first
    let OffBGColor = AppColor.Background.second
    let onImage: SFSymbol = .moonFill
    let offImage: SFSymbol = .sunMaxFill

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(configuration.isOn ? onBGColor : OffBGColor )
                .frame(width: toggleSize.width, height: toggleSize.height, alignment: .center)
                .overlay(
                    ZStack(content: {
                        Image(systemSymbol: configuration.isOn ? onImage : offImage)
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(.yellow)
                            .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.35), radius: 0.3, x: 0.2, y: 0.3)
                            .padding(2)
                    })
                )
                .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.3), radius: 1, x: 0.7, y: 0.7)
                .animation(.linear(duration: 0.2), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
