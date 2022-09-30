//
//  WidgetViewController.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView()
    }
}
