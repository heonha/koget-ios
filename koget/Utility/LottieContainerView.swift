//
//  LottieContainerView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI
import Lottie

struct LottieContainerView: UIViewRepresentable {

    var animationView: LottieAnimationView

    func makeUIView(context: Context) -> UIView {

        let view = UIView(frame: .zero)

        view.addSubview(self.animationView)

        NSLayoutConstraint.activate([
            self.animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }

}
