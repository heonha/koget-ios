//
//  AdPageCell.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import SFSafeSymbols

struct AdPageCell: View {

    var id = UUID()
    var title: String
    var imageName = ""
    var systemName: SFSymbol?

    var body: some View {
        NavigationLink {
            PatchNoteList()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.23), radius: 1, x: -0.4, y: -0.4)
                    .shadow(color: .black.opacity(0.28), radius: 1, x: 0.4, y: 0.4)

                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(3)
                        .opacity(0.2)
                        .padding(.leading, 30)
                }

                HStack(content: {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.custom(CustomFont.NotoSansKR.bold, size: 18))
                            .foregroundColor(AppColor.Label.first)
                        Text(S.adCell)
                            .font(Font.custom(CustomFont.NotoSansKR.light, size: 16))
                            .foregroundColor(.init(uiColor: .secondaryLabel))

                    }
                    .padding(.leading)
                    Spacer()
                })
            }
            .background(.clear)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

struct NoticePageCell_Previews: PreviewProvider {
    static var previews: some View {
        AdPageCell(title: "타이틀")
    }
}
