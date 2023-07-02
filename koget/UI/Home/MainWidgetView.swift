////
////  MainWidgetView.swift
////  BackgroundMaker
////
////  Created by HeonJin Ha on 2022/11/24.
////
//
//import SwiftUI
//import CoreData
//import FloatingButton
//import SFSafeSymbols
//
//// 메인 뷰
//struct MainWidgetView: View {
//
//    @State var isPresentHelper = true
//    @State var isFloatingButtonOpen = false
//    @State var viewType: WidgetViewType = .list
//    
//    @StateObject var viewModel: MainWidgetViewModel
//    @EnvironmentObject var coreData: WidgetCoreData
//    @EnvironmentObject var constant: AppStateConstant
//
//    let onBGColor = AppColor.Fill.first
//    let OffBGColor = AppColor.Background.second
//
//    var body: some View {
//        NavigationView {
//            mainBody()
//                .toolbar {
//                    createToolbar()
//                }
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbarBackground(AppColor.Background.second, for: .navigationBar)
//                .onDisappear {
//                    isFloatingButtonOpen = false
//                }
//        }
//    }
//    
//    func createToolbar() -> some ToolbarContent {
//        Group {
//            // Center
//            ToolbarItem(placement: .navigationBarLeading) {
//                kogetLogoView()
//            }
//            
//            // trailing 2
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Toggle(isOn: $constant.isDarkMode) { }
//                    .toggleStyle(DarkModeToggleStyle())
//            }
//            
//            // trailing 1
//            if !coreData.linkWidgets.isEmpty {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    viewTypeToggle(type: viewType)
//                }
//            }
//        }
//    }
//
//    private func mainBody() -> some View {
//        ZStack {
//            VStack {
//                AdPageContainer()
//                    .padding(.vertical, 4)
//
//                if !coreData.linkWidgets.isEmpty {
//                    WidgetScrollView(viewType: $viewType, viewModel: viewModel)
//                } else {
//                    noWidgetPlaceholder()
//                }
//            }
//            MainFloatingButton(isOpen: $isFloatingButtonOpen)
//        }
//        .background(AppColor.Background.first)
//        .overlay {
//            if viewModel.isPresentEditSheet {
//                if let widget = viewModel.editTarget {
//                    DetailWidgetView(selectedWidget: widget, showDetail: $showDetail)
//                        .transition(.move(edge: .bottom))
//                }
//            }
//        }
//    }
//    
//    private func noWidgetPlaceholder() -> some View {
//        VStack {
//            Spacer()
//            
//            NavigationLink {
//                MakeWidgetView()
//            } label: {
//                VStack(spacing: 8) {
//                    Text(S.MainWidgetView.EmptyGrid.messageLine1)
//                        .font(.custom(.robotoBold, size: 18))
//                        .foregroundColor(Color(uiColor: .tertiaryLabel))
//                        .shadow(color: .black.opacity(0.25), radius: 0.6, x: 1, y: 1)
//                    
//                    Text(S.MainWidgetView.EmptyGrid.messageLine2)
//                        .font(.custom(.robotoBold, size: 20))
//                        .foregroundColor(Color(uiColor: .secondaryLabel))
//                        .shadow(color: .black.opacity(0.25), radius: 0.6, x: 1, y: 1)
//                }
//                .padding(.bottom, 32)
//            }
//            
//            Spacer()
//        }
//    }
//
//    // 뷰 전환 토글
//    private func viewTypeToggle(type: WidgetViewType) -> some View {
//        Button {
//            if type == .list {
//                viewType = .grid
//            } else {
//                viewType = .list
//            }
//        } label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 8)
//                    .foregroundColor(AppStateConstant.shared.isDarkMode ? onBGColor : OffBGColor)
//                    .frame(width: 32, height: 32)
//                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0.7, y: 0.7)
//                
//                Image(systemSymbol: type == .list
//                      ? SFSymbol.listBullet
//                      : SFSymbol.squareGrid3x3)
//                .foregroundColor(AppColor.Label.first)
//                .font(.system(size: 14))
//                .padding(4)
//                .animation(.easeOut, value: viewType)
//            }
//        }
//    }
//
//    private func kogetLogoView() -> some View {
//        CommonImages.koget
//            .toImage()
//            .resizable()
//            .scaledToFit()
//            .frame(width: 50, height: 50)
//    }
//}
//
//struct MainWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        NavigationView {
//            MainWidgetView(viewModel: MainWidgetViewModel())
//                .environmentObject(WidgetCoreData.shared)
//                .environmentObject(AppStateConstant.shared)
//        }
//        
//    }
//}
