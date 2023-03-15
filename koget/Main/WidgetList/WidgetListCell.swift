//
//  WidgetListCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI

// DeepLink - List Cell View
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

    @StateObject var viewModel: MainWidgetViewModel

    // 리스트 셀
    var body: some View {
            HStack {
                ZStack {
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.6), radius: 0.5, x: -0.2, y: -0.5)
                        .shadow(color: .black.opacity(0.6), radius: 0.5, x: 0.2, y: 0.5)

                    Image(uiImage: widgetImage)
                        .resizable()
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.custom(CustomFont.NotoSansKR.medium, size: 16))
                        .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0.2, y: 0.5)
                        .foregroundColor(AppColor.Label.first)

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
                Spacer()
                VStack {
                    // MARK: 실행 횟수
                    runCountView
                }
            }
            .frame(height: cellHeight)

    }

    // 실행 횟수 카운터
    var runCountView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.init(uiColor: .tertiarySystemFill))
                .frame(width: 70, height: 20)
                .shadow(color: .black.opacity(0.4), radius: 0.5, x: 0.2, y: 0.5)
                .opacity(0.7)
            Group {
                HStack(spacing: 2) {
                    Image(systemSymbol: .boltHorizontalFill)
                        .font(.system(size: 13, weight: .semibold))
                        .shadow(color: .black.opacity(0.7), radius: 0.5, x: 0.5, y: 0.5)
                        .foregroundColor(.yellow)
                    Text("\(Int(runCount))")
                        .font(.system(size: 14, weight: .semibold))
                        .shadow(color: .black.opacity(0.6), radius: 0.5, x: 0.3, y: 0.5)
                }
                .foregroundStyle(Color.init(uiColor: .white))
            }
        }
    }

}

struct WidgetListCell_Previews: PreviewProvider {
    static var previews: some View {
        WidgetListCell(name: "이름", url: "https://google.com", widgetImage: UIImage(named: "Koget")!, cellWidth: 40, runCount: 999, cellHeight: 40, viewModel: MainWidgetViewModel.shared)
    }
}
