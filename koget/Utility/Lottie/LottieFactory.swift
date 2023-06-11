//
//  LottieManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI
import Lottie

struct LottieFactory {

    typealias AnimationView = LottieAnimationView
    typealias Animation = LottieAnimation

    enum AnimationType: String {
        case loading = "loading-animation"
        case loadingDot = "loading-dots-animation"
    }

    static func create(type: AnimationType) -> AnimationView {

        let animationView = AnimationView()
        let animationName = type.rawValue

        let animation = Animation.named(animationName)
        animationView.animation = animation
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false

        return animationView
    }

}
