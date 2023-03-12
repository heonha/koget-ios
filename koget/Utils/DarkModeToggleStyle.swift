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
    let onBGColor = AppColor.Fill.first
    let OffBGColor = AppColor.Fill.first
    let onImage: SFSymbol = .moonFill
    let offImage: SFSymbol = .sunMaxFill

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Circle()
                .foregroundColor(configuration.isOn ? onBGColor : OffBGColor )
                .frame(width: toggleSize.width, height: toggleSize.height, alignment: .center)
                .overlay(
                    ZStack(content: {
                        Image(systemSymbol: configuration.isOn ? onImage : offImage)
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

struct CheckMarkToggleStyle: ToggleStyle {

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

struct ToggleTester: View {
    @StateObject var constatnt = Constants.shared
    var body: some View {
        HStack {
            Toggle(isOn: $constatnt.isDarkMode) {
            }
            .toggleStyle(CheckMarkToggleStyle())
            Spacer()
        }
    }
}

struct DarkModeToggleStyle_Previews: PreviewProvider {

    static var previews: some View {
        ToggleTester()
    }
}
