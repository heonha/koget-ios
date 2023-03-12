//
//  CheckmarkToggleStyle.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct CheckmarkToggleStyle: ToggleStyle {

    let toggleSize = CGSize(width: 20, height: 20)

    let tintColor = AppColor.kogetBlue
    let onBGColor = AppColor.Background.first
    let OffBGColor = AppColor.Background.first
    let onImage: SFSymbol = .checkmarkCircleFill
    let offImage: SFSymbol = .circle

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Circle()
                .foregroundColor(configuration.isOn ? onBGColor : OffBGColor )
                .frame(width: toggleSize.width, height: toggleSize.height, alignment: .center)
                .overlay(
                    ZStack(content: {
                        Image(systemSymbol: configuration.isOn ? onImage : offImage)
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(AppColor.kogetBlue)
                            .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.35), radius: 0.5, x: 0.5, y: 1)
                    })

                )
                .shadow(color: .black.opacity(configuration.isOn ? 0 : 0.1), radius: 0.5, x: 0, y: 0)
                .animation(.spring(response: 0.25, dampingFraction: 0.54, blendDuration: 0.1), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
