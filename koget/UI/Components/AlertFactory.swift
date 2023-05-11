//
//  AlertFactory.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/05.
//

import SwiftUI
import SwiftEntryKit
import SFSafeSymbols

struct AlertFactory {

    static var displayMode = EKAttributes.DisplayMode.inferred

    // Attributes
    typealias Attributes = EKAttributes
    typealias Animation = EKAttributes.Animation
    typealias BackgroundStyle = EKAttributes.BackgroundStyle

    // EKProperty
    typealias ButtonContent = EKProperty.ButtonContent
    typealias ImageContent = EKProperty.ImageContent
    typealias LabelStyle = EKProperty.LabelStyle
    typealias LabelContent = EKProperty.LabelContent

    private static let entranceAnimation: Animation = {
        let translate = Animation.Translate(duration: 0.7,spring: .init(damping: 0.7, initialVelocity: 0))
        let scale = Animation.RangeAnimation(from: 0.7, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0))
        return Animation(translate: translate, scale: scale)
    }()

    private static let exitAnimation = Animation(translate: .init(duration: 0.2))

    // MARK: - Attributes
    // EK Attribute (기본)

    enum AlertAttributeType {
        case topFloat, centerFloat, bottomFloat
    }

    private static func defineAttribute(type: AlertAttributeType) -> Attributes {

        switch type {
        case .topFloat:
            return Attributes.topFloat
        case .bottomFloat:
            return Attributes.bottomFloat
        case .centerFloat:
            return Attributes.centerFloat
        }

    }

    static func baseAttribute(type: AlertAttributeType = .topFloat) -> Attributes {

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

    static func makeBaseAlertAttribute(type: AlertAttributeType = .topFloat) -> Attributes {
        return baseAttribute(type: type)
    }

    // MARK: - EKNotificationMessageView
    static func setToastView(title: String,
                             subtitle: String,
                             named: String,
                             size: CGSize = CGSize(width: 50, height: 50)) -> EKNotificationMessageView {

        let title = LabelContent(text: title, style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .black))
        let description = LabelContent(text: subtitle, style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.gray)))
        let image = ImageContent(image: UIImage(named: named) ?? UIImage(systemSymbol: .questionmarkCircle), size: size)
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        return EKNotificationMessageView(with: notificationMessage)
    }

    static func redAlertView(title: String,
                             subtitle: String,
                             named: String,
                             size: CGSize = CGSize(width: 50, height: 50)) -> EKNotificationMessageView {

        let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 18, weight: .bold), color: .white))
        let description = EKProperty.LabelContent(text: subtitle,
                                                  style: .init(font: .systemFont(ofSize: 14, weight: .medium), color: .init(.white)))
        let simpleMessage: EKSimpleMessage = {
            let image = UIImage(named: named) ?? UIImage(systemSymbol: .questionmarkCircle)
            let imageContent = ImageContent(image: image, size: size)
            return EKSimpleMessage(image: imageContent, title: title, description: description)
        }()

        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let view = EKNotificationMessageView(with: notificationMessage)

        return view
    }

    // MARK: - Button Contents

    // ButtonContent
    static let bottomPopupBtn: ButtonContent = {
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

    // MARK: - EKPopUpMessageView
    static func setPopupView(title: String, subtitle: String, named: String, size: CGSize = .init(width: 35, height: 35)) -> EKPopUpMessageView {

        typealias ImageContent = EKProperty.ImageContent

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

        return EKPopUpMessageView(with: popupMessage)
    }

    // MARK: - ETC
    static func voidAction() -> Void { }
    
}

struct EKMaker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MakeWidgetView(assetList: WidgetAssetList(viewModel: MakeWidgetViewModel()))
        }
    }
}
