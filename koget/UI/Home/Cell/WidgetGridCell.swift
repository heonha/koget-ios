//
//  WidgetButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/15.
//

import SwiftUI
import CoreData

struct WidgetGridCell: View {
    var name: String
    var url: String
    var widgetImage: UIImage
    var cellWidth: CGFloat
    var imageSize: CGSize
    var textSize: CGSize

    let titleColor: Color = AppColor.Label.first
    @ObservedObject var viewModel: MainWidgetViewModel

    init(name: String, url: String, widgetImage: UIImage, cellWidth: CGFloat, viewModel: MainWidgetViewModel) {
        self.name = name
        self.url = url
        self.widgetImage = widgetImage
        self.cellWidth = cellWidth
        self.imageSize = CGSize(width: cellWidth * 0.63, height: cellWidth * 0.63)
        self.textSize = CGSize(width: cellWidth, height: cellWidth * 0.40)
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 2) {

            //MARK: 위젯 아이콘
            ZStack {
                // 아이콘배경
                AppColor.Background.first
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0.5, y: 0.5)
                
                Image
                    .uiImage(widgetImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                WidgetGridLinkTypeIcon(viewModel: viewModel, url: url)
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .shadow(color: .black.opacity(0.15), radius: 0.5, x: 0.3, y: 0.3)
            .shadow(color: .black.opacity(0.15), radius: 0.5, x: -0.3, y: -0.3)

            //MARK: 위젯 이름
            Text(name)
                .font(.custom(.robotoMedium, size: 12))
                .foregroundColor(titleColor)
                .shadow(radius: 0.5, x: 0.5, y: 0.5)
                .frame(width: textSize.width, height: textSize.height)
                .lineLimit(2)
                .frame(height: 30)
            
        }
        .background(viewModel.isEditingMode ? Color.init(uiColor: .secondarySystemFill) : .clear)
        .frame(width: cellWidth, height: cellWidth * 1.15)
        .clipShape(RoundedRectangle(cornerRadius: 8))

    }
}

struct WidgetButton_Previews: PreviewProvider {
    static var previews: some View {
        WidgetGridCell(name: "위젯이름", url: "https://google.com", widgetImage: UIImage.init(named: "navermap")!, cellWidth: Constants.widgetCellWidthForGrid, viewModel: MainWidgetViewModel())
    }
}
