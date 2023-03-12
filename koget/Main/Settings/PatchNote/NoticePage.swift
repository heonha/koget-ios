//
//  NoticePage.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI
import SFSafeSymbols

// 메인화면 공지 Cell
struct NoticePage: View {
    var frame: CGSize = .init(width: .zero, height: deviceSize.height / 7.5)

    var url = "https://www.heon.dev/patchnote/patchnote1-1.jpg"

    var body: some View {
        ZStack {
            AppColor.Background.first
            TabView {
                NavigationLink {
                    PatchNoteList()
                } label: {
                    NoticePageCell(title: "UPDATED 1.2", named: "KogetClear", frame: frame.height)
                        .padding()
                }

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
