//
//  NoticeImageView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/12.
//

import SwiftUI
import Kingfisher

struct PatchNoteContentView: View {

    var baseURL: String = "https://website.heon.dev/patchnote"
    var fileName: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .top)
            VStack {
                ScrollView {
                    KFImage(URL(string: baseURL + fileName)!)
                        .placeholder({ progress in
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppColor.Label.second))
                        })
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

struct PatchNoteContentView_Previews: PreviewProvider {
    static var previews: some View {
        PatchNoteContentView(baseURL: "https://www.heon.dev/patchnote/", fileName: "patchnote-en-light-1-1.png")
    }
}
