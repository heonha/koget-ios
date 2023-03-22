//
//  AdPage.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI
import SFSafeSymbols

// 메인화면 공지 Cell
struct AdPageContainer: View {

    var pageList = [AdPageCell(title: "UPDATED 1.2", imageName: "KogetClear")]

    var height: CGFloat = deviceSize.height / 7.5

    var body: some View {
        TabView {
            ForEach(pageList, id: \.id) { list in
                list
            }
            .padding(.vertical, 8)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: height)
        .background(AppColor.Background.first)
    }
}

struct NoticePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdPageContainer()
        }
    }
}
