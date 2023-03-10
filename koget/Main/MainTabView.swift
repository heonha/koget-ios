//
//  MainTabView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI
import SFSafeSymbols

struct MainTabView: View {
    @ObservedObject var viewModel = MainWidgetViewModel.shared

    var body: some View {
        TabView {
            MainWidgetView(viewModel: viewModel)
                .tabItem {
                    Image(systemSymbol: SFSymbol.rectangleGrid1x2)
                }
            SettingMenu()
                .tabItem {
                    Image(systemSymbol: SFSymbol.gearshape)
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
