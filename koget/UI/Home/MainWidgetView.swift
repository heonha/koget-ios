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
    
    let backgroundColor = AppColor.Background.first

    @State var isPresentHelper = true
    @State var isFloatingButtonOpen = false

    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @EnvironmentObject var constant: Constants

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    AdPageContainer()
                        .padding(.vertical, 4)
                    // 링크위젯
                    WidgetListContainerView(viewModel: viewModel, coreData: _coreData)
                }
                .background(backgroundColor)
                MainFloatingButton(isOpen: $isFloatingButtonOpen)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // 중앙 이미지
                    navigationBarCenterImage()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    // 다크모드 버튼
                    Toggle(isOn: $constant.isDarkMode) {
                    }
                    .toggleStyle(DarkModeToggleStyle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {

                    // 뷰 전환 토글
                    if !$coreData.linkWidgets.wrappedValue.isEmpty {
                        Button {
                            viewModel.isGridView.toggle()
                        } label: {
                            Image(systemSymbol: viewModel.isGridView
                                  ? SFSymbol.listBullet
                                  : SFSymbol.squareGrid3x3)
                            .foregroundColor(AppColor.Label.first)
                            .opacity(0.9)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.isGridView)
                        }
                    }
                }
            }
            .onDisappear {
                isFloatingButtonOpen = false
            }
        }
        
    }

    func navigationBarCenterImage() -> some View {
        Image("KogetClear")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView(viewModel: MainWidgetViewModel.shared)
        }
        
    }
}
