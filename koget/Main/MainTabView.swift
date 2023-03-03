//
//  MainTabView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/03.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = MainWidgetViewModel.shared

    @State var index = 0

    var body: some View {
        TabView(selection: $index) {
            MainWidgetView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2")
                    Text("위젯")
                }
            SettingMenu()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("설정")
                }
        }
        .tint(.init("deepDarkGray"))

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
