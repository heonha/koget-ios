//
//  NoticeImageView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import Kingfisher

struct NoticeImageView: View {

    var baseURL: String = "https://www.heon.dev/patchnote/"
    var fileName: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .top)
            VStack {
                ScrollView {
                    KFImage(URL(string: baseURL + fileName)!)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

struct NoticeImageView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeImageView(baseURL: "https://www.heon.dev/patchnote/", fileName: "patchnote-en-light-1-1.png")
    }
}
