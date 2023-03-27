//
//  SUIView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/04.
//

import SwiftUI

struct SUIView: UIViewRepresentable {
    typealias UIViewType = UIView

    let rootView: UIView

    func makeUIView(context: Context) -> UIView {
        let view = rootView
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}
