//
//  NoticePageCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct NoticePageCell: View {

    var title: String
    var named = ""
    var systemName: SFSymbol?
    var frame: CGFloat

    var body: some View {
        ZStack {
            AppColor.Background.second
            ZStack {
                HStack {
                    Spacer()
                    Image(named)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(3)
                        .opacity(0.2)
                        .padding(.leading, 30)
                }
                HStack {
                    Spacer()
                    if !named.isEmpty {

                    } else if let symbol = systemName {
                        Image(systemSymbol: symbol)
                            .font(.system(size: 40))
                            .padding(12)
                    }
                }
                HStack(content: {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.custom(CustomFont.NotoSansKR.bold, size: 18))
                            .foregroundColor(AppColor.Label.first)
                        Text("새로워진 코젯 확인하기")
                            .font(Font.custom(CustomFont.NotoSansKR.light, size: 16))
                            .foregroundColor(.init(uiColor: .secondaryLabel))

                    }
                    .padding(.leading)
                    Spacer()
                })
            }
        }
        .background(AppColor.Background.second)
        .cornerRadius(10)
        .shadow(radius: 2)
        .tint(.black)
        .padding(.horizontal)
    }
}

struct NoticePageCell_Previews: PreviewProvider {
    static var previews: some View {
        NoticePageCell(title: "타이틀", frame: 100)
    }
}
