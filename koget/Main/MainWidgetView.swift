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
import SwiftEntryKit
import WelcomeSheet

// 메인 뷰
struct MainWidgetView: View {
    
    var tintColor: Color = .black
    @State var isPresentHelper = true
    @State var isOpen = false
    @StateObject var viewModel: MainWidgetViewModel
    @EnvironmentObject var coreData: WidgetCoreData
    // @Environment(\.viewController) var viewControllerHolder: UIViewController?

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    NoticePage()
                        .padding(.vertical, 4)
                    // 링크위젯
                    LinkWidgetView(viewModel: viewModel, coreData: _coreData)
                }
                .background(Color.init(uiColor: .systemBackground))

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
                isOpen = false
            }

        }
        .tint(.black)
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
