//
//  NoticePage.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI
import SFSafeSymbols

struct NoticePage: View {
    var frame: CGSize = .init(width: .zero, height: deviceSize.height / 7.5)
    var body: some View {
        ZStack {
            AppColor.Background.first
            TabView {
                NoticePageCell(named: "KogetClear", frame: frame.height)
                    .padding(.vertical)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(height: frame.height)
    }
}

struct NoticePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoticePage()
        }
    }
}
