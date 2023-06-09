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
    var image: Image
    var systemName: SFSymbol?

    var body: some View {
        NavigationLink {
            PatchNoteList()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .fill(AppColor.Background.second)
                    .shadow(color: .black.opacity(0.23), radius: 1, x: -0.4, y: -0.4)
                    .shadow(color: .black.opacity(0.28), radius: 1, x: 0.4, y: 0.4)

                HStack {
                    Spacer()
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(3)
                        .opacity(0.2)
                        .padding(.leading, 30)
                }

                HStack(content: {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(Font.custom(.robotoBold, size: 18))
                            .foregroundColor(AppColor.Label.first)
                        Text(S.adCell)
                            .font(Font.custom(.robotoLight, size: 16))
                            .foregroundColor(.init(uiColor: .secondaryLabel))

                    }
                    .padding(.leading)
                    Spacer()
                })
            }
            .background(AppColor.Background.second.opacity(0.4))
            .cornerRadius(10)
        }
    }
}

struct NoticePageCell_Previews: PreviewProvider {
    static var previews: some View {
        AdPageCell(title: "타이틀", image: CommonImages.koget.toImage())
    }
}
