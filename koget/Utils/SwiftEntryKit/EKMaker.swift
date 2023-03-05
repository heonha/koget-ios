//
//  EKMaker.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/05.
//

import SwiftUI
import SwiftEntryKit
import Localize_Swift

struct EKMaker {

    static var displayMode = EKAttributes.DisplayMode.inferred

    // MARK: - Alert

    static let bottomAlertAttributes: EKAttributes = {
        var attributes = EKAttributes.topFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.screenBackground = .color(color: .clear)
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        attributes.roundCorners = .all(radius: 25)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        attributes.positionConstraints.verticalOffset = 10
        attributes.positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.minEdge),
            height: .intrinsic
        )
        attributes.statusBar = .inferred
        
        return attributes
    }()

    static func setToastView(title: String, subtitle: String, named: String, size: CGSize = .init(width: 50, height: 50)) -> EKNotificationMessageView {

        let title = EKProperty.LabelContent(text: title.localized(), style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .black))
        let description = EKProperty.LabelContent(text: subtitle.localized(), style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.gray)))
        let image = EKProperty.ImageContent(image: UIImage(named: named) ?? UIImage(systemName: "questionmark.fill")!, size: size)
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        return EKNotificationMessageView(with: notificationMessage)
    }

    static func redAlertView(title: String, subtitle: String, named: String, size: CGSize = .init(width: 50, height: 50)) -> EKNotificationMessageView {

        let title = EKProperty.LabelContent(text: title.localized(), style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .white))
        let description = EKProperty.LabelContent(text: subtitle.localized(), style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.white)))
        let image = EKProperty.ImageContent(image: UIImage(named: named) ?? UIImage(systemName: "questionmark.fill")!, size: size)
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        return EKNotificationMessageView(with: notificationMessage)
    }

    // MARK: - Popup Message

    static let bottomPopupBtn = EKProperty.ButtonContent(
        label: .init(
            text: "",
            style: .init(
                font: UIFont(name: CustomFont.NotoSansKR.light, size: 16)!,
                color: .init(.label),
                displayMode: displayMode
            )
        ),
        backgroundColor: .init(.clear),
        highlightedBackgroundColor: .black.with(alpha: 0),
        displayMode: displayMode,
        accessibilityIdentifier: "bottomPopupBtn"
    )

    /// backgroundColor: white, displayDutation: 1.5
    static let whiteAlertAttribute: EKAttributes = {
        var attributes = EKAttributes()

        attributes = bottomAlertAttributes
        attributes.displayMode = displayMode
        attributes.entryBackground = .color(color: .white)
        attributes.popBehavior = .overridden
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.7, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.displayDuration = 1.5

        return attributes
    }()

    static let redAlertAttribute: EKAttributes = {
        var attributes = EKAttributes()

        attributes = bottomAlertAttributes
        attributes.displayMode = displayMode
        attributes.entryBackground = .color(color: .init(.systemRed))
        attributes.popBehavior = .overridden
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 0.7, initialVelocity: 0)
            ),
            scale: .init(
                from: 0.7,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )

        attributes.displayDuration = 2

        return attributes
    }()

    static func setPopupView(title: String, subtitle: String, named: String, size: CGSize = .init(width: 35, height: 35)) -> EKPopUpMessageView {

        let title = EKProperty.LabelContent(text: title.localized(), style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .black))
        let description = EKProperty.LabelContent(text: subtitle.localized(), style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.gray)))
        // let image = EKProperty.ImageContent(image: UIImage(named: named) ?? UIImage(systemName: "questionmark.fill")!, size: size)
        let image = UIImage(named: named) ?? UIImage(systemName: "questionmark.fill")!
        // let themeImage = EKPopUpMessage.ThemeImage(image: image, position: .centerToTop(offset: 12))
        var themes: EKPopUpMessage.ThemeImage? = nil
        themes = .init(.init(image: .thumb(with: image, edgeSize: 100)))
        let popupMessage = EKPopUpMessage(themeImage: themes, title: title, description: description,
                                          button: bottomPopupBtn, action: voidAction)
        return EKPopUpMessageView(with: popupMessage)
    }

    static func voidAction() -> Void {
        debugPrint("btn Action")
    }
}

struct EKMaker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}
