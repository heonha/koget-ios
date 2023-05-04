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
            .background(AppColor.Background.second)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(.horizontal)
        }
    }
}

struct NoticePageCell_Previews: PreviewProvider {
    static var previews: some View {
        AdPageCell(title: "타이틀")
    }
}
