//
//  WidgetButton.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/15.
//

import SwiftUI
import CoreData

struct WidgetGridCell: View {
    
    var widget: DeepLink
    
    private var cellWidth: CGFloat = Constants.deviceSize.width / 4.3
    private var imageSize: CGSize = .zero
    private var textSize: CGSize = .zero
    
    private var name: String = ""
    private var url: String = ""
    private var image: UIImage = UIImage()
    private let titleColor: Color = AppColor.Label.first

    @ObservedObject var viewModel: MainWidgetViewModel

    init(widget: DeepLink, viewModel: MainWidgetViewModel) {
        self.widget = widget
        self.viewModel = viewModel
        
        name = widget.name ?? ""
        url = widget.url ?? ""
        let imageData = widget.image ?? Data()
        image = UIImage(data: imageData) ?? CommonImages.emptyIcon
        imageSize = CGSize(width: cellWidth * 0.63, height: cellWidth * 0.63)
        textSize = CGSize(width: cellWidth, height: cellWidth * 0.40)
    }

    var body: some View {
        VStack(spacing: 2) {
            //MARK: 위젯 아이콘
            ZStack {
                // 아이콘배경
                AppColor.Background.first
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.25), radius: 0.5, x: 0.5, y: 0.5)
                    .shadow(color: .black.opacity(0.25), radius: 0.5, x: -0.5, y: -0.5)

                Image
                    .uiImage(image.addClearBackground(sourceResizeRatio: 1.0) ?? CommonImages.emptyIcon)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            }
            .frame(width: imageSize.width, height: imageSize.height)

            //MARK: 위젯 이름
            Text(name)
                .font(.custom(.robotoMedium, size: 13))
                .foregroundColor(titleColor)
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
        WidgetGridCell(widget: DeepLink.example, viewModel: MainWidgetViewModel())
    }
}
