//
//  TestImageView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/11.
//

import SwiftUI

struct TestImageView: View {
    let url = URL(string: "https://cdn.simpleicons.org/swift")!

    var body: some View {
        AsyncImageView(url: url) {
            Text("Loading ...")
        }.aspectRatio(contentMode: .fit)
    }
}

#if DEBUG
struct TestImageView_Previews: PreviewProvider {
    static var previews: some View {

        TestImageView()

    }
}
#endif
