//
//  MainWidgetView.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import SwiftUI
import CoreData
import FloatingButton
import ToastUI

// 메인 뷰
struct MainWidgetView: View {
    
    
    var tintColor: Color = .black
    @State var isPresentHelper = true
    @State var isOpen = false
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    
    @Environment(\.viewController) var viewControllerHolder: UIViewController?
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.secondaryBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Rectangle()
                        .frame(width: DEVICE_SIZE.width, height: 8)
                        .foregroundStyle(Color.init(uiColor: .secondarySystemBackground))
                    // 링크위젯
                    LinkWidgetView(viewModel: viewModel, coreData: _coreData)
                }
                NewFloatingButton(isOpen: $isOpen)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("KogetLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !$coreData.linkWidgets.wrappedValue.isEmpty {
                        
                        Button {
                            viewModel.isGridView.toggle()
                        } label: {
                            Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.3x3")
                                .foregroundColor(.init(uiColor: .label))
                                .opacity(0.9)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.isGridView)
                        }
                    }

                }

            }
            .onTapGesture {
                isOpen = false
            }
            .onDisappear {
                print("Disappear")
                isOpen = false
            }

        }
        .tint(.black)
        .toast(isPresented: $viewModel.makeSuccessful, dismissAfter: 1.3) {
        } content: {
            ToastAlert(jsonName: .normal, title: "위젯 생성 완료!".localized(), subtitle: "코젯앱을 잠금화면에 추가해 사용하세요.".localized())
        }
        .toast(isPresented: $viewModel.deleteSuccessful, dismissAfter: 0.7, onDismiss: {
        }) {
            ToastAlert(jsonName: .trash, title: "위젯 삭제 완료!".localized(), subtitle: nil)
        }
        .welcomeSheet(isPresented: $viewModel.isFirstRun, isSlideToDismissDisabled: true, pages: HelperSheetViewModel.shared.pages)
    }
}


struct MainWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            MainWidgetView(viewModel: MainWidgetViewModel.shared)
        }
        
    }
}
