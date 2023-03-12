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
import WelcomeSheet
import SFSafeSymbols

// 메인 뷰
struct MainWidgetView: View {
    
    var tintColor: Color = .black
    @State var isPresentHelper = true
    @State var isOpen = false
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    @EnvironmentObject var constant: Constants
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    NoticePage()
                        .padding(.vertical, 4)
                    // 링크위젯
                    WidgetListContainerView(viewModel: viewModel, coreData: _coreData)
                }
                .background(AppColor.Background.first)
                NewFloatingButton(isOpen: $isOpen)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("KogetClear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Toggle(isOn: $constant.isDarkMode) {
                    }
                    .toggleStyle(DarkModeToggleStyle())
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !$coreData.linkWidgets.wrappedValue.isEmpty {
                        
                        Button {
                            viewModel.isGridView.toggle()
                        } label: {
                            Image(systemSymbol: viewModel.isGridView ? SFSymbol.listBullet : SFSymbol.squareGrid3x3)
                                .foregroundColor(AppColor.Label.first)
                                .opacity(0.9)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.isGridView)
                        }
                    }
                }
            }
            .welcomeSheet(isPresented: $viewModel.isFirstRun, isSlideToDismissDisabled: true, pages: HelperSheetViewModel.shared.pages)
            .onTapGesture {
                isOpen = false
            }
            .onDisappear {
                isOpen = false
            }
        }
        
    }
}

struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView(viewModel: MainWidgetViewModel.shared)
        }
        
    }
}
