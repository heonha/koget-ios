//
//  WidgetListCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct WidgetListCell: View {

    var name: String
    var url: String
    var widgetImage: UIImage
    var cellWidth: CGFloat
    var runCount: Int
    var cellHeight: CGFloat

    let app: String = S.WidgetCell.WidgetType.app
    let web: String = S.WidgetCell.WidgetType.web
    var imageSize = CGSize(width: 40, height: 40)
    let titleColor: Color = AppColor.Label.first

    @ObservedObject var viewModel: MainWidgetViewModel

}

extension WidgetListCell {

    // 리스트 셀
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColor.Background.first)

            HStack(spacing: 16) {
                imageView

                textVStack

                Spacer()

                runCountView
            }
        }
        .frame(height: cellHeight)
    }

    // 실행 횟수 카운터
    var runCountView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(AppColor.Fill.third)
                .frame(width: 70, height: 30)

            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 0.3)
                .fill(AppColor.Fill.third)
                .frame(width: 70, height: 30)
                .shadow(color: .black.opacity(0.2), radius: 2, x: -0.4, y: -0.5)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0.4, y: 0.5)

                HStack(spacing: 6) {
                    Image(systemSymbol: .boltHorizontalFill)
                        .font(.system(size: 11, weight: .semibold))
                        .shadow(color: .black.opacity(0.7), radius: 0.5, x: 0.5, y: 0.5)
                        .foregroundColor(.yellow)
                    Text("\(Int(runCount))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColor.Background.first)
                        .shadow(color: .black.opacity(0.8), radius: 0.5, x: 0.3, y: 0.5)
            }
        }
    }

    var imageView: some View {
        ZStack {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 1.5, x: -0.3, y: -0.5)
                .shadow(color: .black.opacity(0.2), radius: 1.5, x: 0.3, y: 0.5)

            Image(uiImage: widgetImage)
                .resizable()
                .clipShape(Circle())
        }
        .frame(width: imageSize.width, height: imageSize.height)
    }

    var textVStack: some View {

        VStack(alignment: .leading) {
            // title
            Text(name)
                .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
                .foregroundColor(AppColor.Label.first)

            // subtitle
            switch viewModel.checkLinkType(url: url) {
            case .app:
                Text(app)
                    .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                    .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
            case .web:
                Text(web)
                    .font(.custom(CustomFont.NotoSansKR.regular ,size: 13))
                    .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
            }

        }

    }

}

struct WidgetListCell_Previews: PreviewProvider {
    static var previews: some View {
        WidgetListCell(name: "이름", url: "https://google.com", widgetImage: UIImage(named: "Koget")!, cellWidth: 40, runCount: 999, cellHeight: 40, viewModel: MainWidgetViewModel())
    }
}
