//
//  AsyncImageView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/11.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.loadSVG)
    }

    private var content: some View {
           Group {
               if let image = loader.image {
                   Image(uiImage: image)
                       .resizable()
               } else {
                   placeholder
               }
           }
       }
}
