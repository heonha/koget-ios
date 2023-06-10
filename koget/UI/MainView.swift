//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI
import UIKit

struct MainView: View {

    @EnvironmentObject var constant: AppStateConstant
    @StateObject var viewModel = MainWidgetViewModel()

    var body: some View {
        MainTabView(viewModel: viewModel)
            .preferredColorScheme(constant.isDarkMode ? .dark : .light)
            .animation(.linear(duration: 0.2), value: constant.isDarkMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
