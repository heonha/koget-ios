//
//  AlertFactory.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/05.
//

import SwiftUI
import SwiftEntryKit
import SFSafeSymbols

class AlertFactory {

    static let shared = AlertFactory()

    enum AlertAttributeType {
        case topFloat, centerFloat, bottomFloat
    }

    // Attributes
    private typealias Attributes = EKAttributes
    private typealias Animation = EKAttributes.Animation
    private typealias BackgroundStyle = EKAttributes.BackgroundStyle

    // EKProperty
    private typealias ButtonContent = EKProperty.ButtonContent
    private typealias ImageContent = EKProperty.ImageContent
    private typealias LabelStyle = EKProperty.LabelStyle
    private typealias LabelContent = EKProperty.LabelContent

    private let entranceAnimation: Animation = {
        let translate = Animation.Translate(duration: 0.7,spring: .init(damping: 0.7, initialVelocity: 0))
        let scale = Animation.RangeAnimation(from: 0.7, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0))
        return Animation(translate: translate, scale: scale)
    }()

    private let exitAnimation = Animation(translate: .init(duration: 0.2))
    private let displayMode = EKAttributes.DisplayMode.inferred

    private func voidAction() -> Void { }
    private var alertView = UIView()

}

extension AlertFactory {

    func makeBaseAlertAttribute(type: AlertAttributeType = .topFloat) -> EKAttributes {
        return baseAttribute(type: type)
    }

}

extension AlertFactory {

    // MARK: - Attributes
    private func defineAttribute(type: AlertAttributeType) -> Attributes {
        switch type {
        case .topFloat:
            return Attributes.topFloat
        case .bottomFloat:
            return Attributes.bottomFloat
        case .centerFloat:
            return Attributes.centerFloat
        }
    }

    private func baseAttribute(type: AlertAttributeType = .topFloat) -> Attributes {

        // Base (Root)
        var attribute = defineAttribute(type: type)
        attribute.hapticFeedbackType = .success
        attribute.displayDuration = .infinity
        attribute.statusBar = .inferred

        // Display
        attribute.displayMode = displayMode
        attribute.displayDuration = 1.5

        //Position
        attribute.positionConstraints.verticalOffset = 10
        attribute.positionConstraints.size = .init(width: .offset(value: 20), height: .intrinsic)
        attribute.positionConstraints.maxSize = .init( width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)

        // backgrounds
        attribute.entryBackground = .color(color: EKColor.standardBackground)
        attribute.screenBackground = .color(color: .clear)
        attribute.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))

        // interections
        attribute.screenInteraction = .dismiss
        attribute.entryInteraction = .absorbTouches
        attribute.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)

        //Animation
        attribute.entranceAnimation = entranceAnimation
        attribute.exitAnimation = exitAnimation
        attribute.roundCorners = .all(radius: 25)
        attribute.popBehavior = .animated(animation: Animation(translate: .init(duration: 0.2)))

        return attribute
    }
}

// MARK: - MessageView
extension AlertFactory {

    func showAlert() {
        SwiftEntryKit.display(entry: alertView, using: makeBaseAlertAttribute())
    }

    func setToastView(title: String,
                             subtitle: String,
                             named: String) {
        // Contents
        let imageSize = CGSize(width: 50, height: 50)
        let image = ImageContent(image: UIImage(named: named) ?? UIImage(systemSymbol: .questionmarkCircle),
                                 size: imageSize)
        let title = LabelContent(text: title, style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .black))
        let description = LabelContent(text: subtitle, style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.gray)))

        // Containers
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        self.alertView = EKNotificationMessageView(with: notificationMessage)
    }

    func setPopupView(title: String, subtitle: String, named: String) {
        // ButtonContent
        let bottomPopupBtn: ButtonContent = {
            // Label style
            let style: LabelStyle = {
                let font = UIFont(name: CustomFont.NotoSansKR.light, size: 16)!
                let color = EKColor.init(UIColor(AppColor.Label.first))

                return LabelStyle(font: font, color: color, displayMode: displayMode)
            }()

            let label = LabelContent(text: "", style: style)

            // Background
            let backgroundColor = EKColor(.clear)
            let highlightedBackgroundColor = EKColor.black.with(alpha: 0)

            // id
            let accessibilityIdentifier = "bottomPopupBtn"

            return ButtonContent(label: label,
                                 backgroundColor: backgroundColor,
                                 highlightedBackgroundColor: highlightedBackgroundColor,
                                 accessibilityIdentifier: accessibilityIdentifier)
        }()

        let title: LabelContent = {
            let style = LabelStyle(font: .systemFont(ofSize: 18, weight: .bold), color: .black)
            return LabelContent(text: title, style: style)
        }()

        let description: LabelContent = {
            let style = LabelStyle(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.gray))
            return LabelContent(text: subtitle, style: style)
        }()

        let themes: EKPopUpMessage.ThemeImage = {
            let image = UIImage(named: named) ?? UIImage(systemSymbol: .questionmarkCircle)
            let imageContent = ImageContent.thumb(with: image, edgeSize: 100)
            return EKPopUpMessage.ThemeImage(image: imageContent)
        }()

        let popupMessage = EKPopUpMessage(themeImage: themes, title: title, description: description,
                                          button: bottomPopupBtn, action: voidAction)

        self.alertView = EKPopUpMessageView(with: popupMessage)
    }
}

#if DEBUG
struct EKMaker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}
#endif
