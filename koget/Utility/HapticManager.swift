//
//  HapticManager.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
