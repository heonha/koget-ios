//
//  BlurBackgroundView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI

struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        var viewController: UIViewController?
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        viewController = firstScene?.windows.first?.rootViewController
        return ViewControllerHolder(value: viewController )
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.modalTransitionStyle = transitionStyle
        toPresent.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
                .environmentObject(AppStateConstant.shared)
        )
        self.present(toPresent, animated: true, completion: nil)
    }
}
