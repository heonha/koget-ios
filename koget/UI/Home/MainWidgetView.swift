//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import FloatingButton
import SwiftEntryKit
import SFSafeSymbols

// 메인 뷰
struct MainWidgetView: View {

    @State var isPresentHelper = true
    @State var isFloatingButtonOpen = false

    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @EnvironmentObject var constant: AppStateConstant

    var body: some View {
        NavigationView {
            mainBody()
                .toolbar {
                    // Center
                    ToolbarItem(placement: .navigationBarLeading) {
                        navigationBarCenterImage()
                    }
                    // leading
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Toggle(isOn: $constant.isDarkMode) { }
                            .toggleStyle(DarkModeToggleStyle())
                    }
                    // trailing
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !$coreData.linkWidgets.wrappedValue.isEmpty {
                            changeAppearanceButton
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.init(uiColor: .secondarySystemBackground), for: .navigationBar)
                .onDisappear {
                    isFloatingButtonOpen = false
                }
        }
    }

    private func mainBody() -> some View {
        ZStack {
            AppColor.Background.first
            VStack {
                AdPageContainer()
                    .padding(.vertical, 4)
                // 링크위젯
                WidgetListContainerView(viewModel: viewModel, coreData: _coreData)
            }
            MainFloatingButton(isOpen: $isFloatingButtonOpen)
        }
    }

    // 뷰 전환 토글
    private var changeAppearanceButton: some View {
        Button {
            viewModel.isGridView.toggle()
        } label: {
            Image(systemSymbol: viewModel.isGridView
                  ? SFSymbol.listBullet
                  : SFSymbol.squareGrid3x3)
            .foregroundColor(AppColor.Label.first)
            .opacity(0.56)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isGridView)
        }
    }

    private func navigationBarCenterImage() -> some View {
        Image("KogetClear")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView(viewModel: MainWidgetViewModel())
        }
        
    }
}
