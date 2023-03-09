//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI
import UIKit

import SwiftEntryKit

struct ContentView: View {

    @EnvironmentObject var constant: Constants
    @State var isDebugMode = false
    
    var body: some View {
        MainTabView()
            .preferredColorScheme(constant.isDarkMode ? .dark : .light)
            .animation(.linear(duration: 0.2), value: constant.isDarkMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
