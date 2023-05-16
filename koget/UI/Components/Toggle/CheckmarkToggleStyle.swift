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

    let onBGColor = AppColor.Background.third
    let OffBGColor = AppColor.Background.third
    let onImage: SFSymbol = .checkmarkCircleFill
    let offImage: SFSymbol = .circleFill

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
                            .foregroundColor(configuration.isOn ? .init(uiColor: .secondaryLabel) : .init(uiColor: .tertiaryLabel))
                    })
                )
                .animation(.spring(response: 0.25, dampingFraction: 0.54, blendDuration: 0.1), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

#if DEBUG
struct CheckmarkToggleStyle_Previews: PreviewProvider {

    static var previews: some View {
        WidgetAssetList(viewModel: MakeWidgetViewModel())
    }
}
#endif
