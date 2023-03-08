//
//  FloatingDestinationView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/15.
//

import SwiftUI

struct FloatingDestinationView: View {
    var type: NavigationLinkType

    var body: some View {
        switch type {
        case .add:
            MakeWidgetView()
        case .aboutApp:
            SettingMenu()
        case .contact:
            ContactView()
        case .edit:
            ManageWidgetView()
        }
    }
}

struct FloatingDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingDestinationView(type: .aboutApp)
    }
}
