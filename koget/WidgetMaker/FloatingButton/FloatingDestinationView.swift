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
        case .setting:
            SettingView()
        }
    }
}


struct FloatingDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingDestinationView(type: .setting)
    }
}
