//
//  SettingMenuButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct SettingMenuButton: View {

    enum ImageType {
        case symbol
        case asset
    }

    var title: String
    var subtitle: String? = nil
    var imageType: ImageType
    var imageName: String = ""
    var systemSymbol: SFSymbol?
    var imageSize: CGFloat = 20
    var imageColor: Color = AppColor.Label.first
    var action: () -> Void

    var titleColor: Color = AppColor.Label.first
    var subtitleColor: Color = AppColor.Label.second

    var body: some View {
        Button {
            action()
        } label: {
            LazyHStack {

                switch imageType {
                case .symbol:
                    if let symbol = systemSymbol {
                        Image(systemSymbol: symbol)
                            .tint(imageColor)
                            .shadow(color: Color.black.opacity(0.2), radius: 0.1, x: 1, y: 1)
                            .frame(width: imageSize)
                    }
                case .asset:
                    Image(imageName)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                }

                LazyHStack {
                    Text(title)
                        .foregroundStyle(titleColor)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundStyle(subtitleColor)
                    }
                }
            }
        }
    }
}

struct SettingMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingMenuButton(title: "타이틀", imageType: SettingMenuButton.ImageType.symbol) {
            
        }
    }
}
