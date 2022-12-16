//
//  SettingButtonLabel.swift
//  QuickGet
//
//  Created by HeonJin Ha on 2022/12/16.
//

import SwiftUI

struct SettingButtonLabel: View {
    
    var title: LocalizedStringKey
    var symbolName: String
    
    var body: some View {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: symbolName)
                    .foregroundColor(.white)
            }.tint(.white)
    }
}

struct SettingButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        SettingButtonLabel(title: "공지사항", symbolName: "gearshape")
    }
}
