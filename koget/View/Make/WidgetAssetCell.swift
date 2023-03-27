//
//  WidgetAssetCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI

struct WidgetAssetCell: View {

    @StateObject var viewModel: MakeWidgetViewModel

    var widget: LinkWidget
    var imageSize: CGSize = .init(width: 40, height: 40)
    var textColor: Color = AppColor.Label.first
    var installTextColor: Color = AppColor.Label.second

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            viewModel.getWidgetData(selectedWidget: widget)
            dismiss()
        } label: {
            LazyHStack {
                ZStack {
                    Color.white
                    Image(uiImage: widget.image ?? UIImage(named: "questionmark.circle")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize.width, height: imageSize.height)
                }
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.3, y: 0.3)
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: -0.3, y: -0.3)

                .padding([.trailing, .vertical], 4)
                VStack(alignment: .leading) {
                    HStack {
                        Text(widget.displayName)
                            .fontWeight(.semibold)
                        .foregroundColor(textColor)
                        if !widget.canOpen {
                            Text(S.WidgetAssetList.notInstalled)
                                .font(.custom(CustomFont.NotoSansKR.bold, size: 14))
                                .foregroundColor(installTextColor)
                        }
                    }
                    Text(MainWidgetViewModel.shared.checkLinkType(url: widget.url).localizedString)
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 12))
                        .foregroundColor(installTextColor)
                        .padding(.leading, 1)
                }
            }
        }
        .disabled(!widget.canOpen)
    }
}

struct WidgetAssetCell_Previews: PreviewProvider {
    static var previews: some View {
        WidgetAssetCell(viewModel: MakeWidgetViewModel(), widget: LinkWidget.init(name: "Tmap", nameKr: "티맵", nameEn: "Tmap", url: "tmap://", imageName: "tmap"))
    }
}
