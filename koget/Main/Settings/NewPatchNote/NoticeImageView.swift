//
//  NoticeImageView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import Kingfisher

struct NoticeImageView: View {

    var url: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .top)
            VStack {
                ScrollView {
                    KFImage(URL(string: url)!)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

struct NoticeImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeImageView(url: "https://www.heon.dev/patchnote/patchnote1-1.jpg")
    }
}
