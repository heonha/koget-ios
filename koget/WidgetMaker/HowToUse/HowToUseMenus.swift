//
//  HowToUseMenus.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/24.
//

import SwiftUI
import WelcomeSheet

struct HowToUseMenus: View {
    
    @ObservedObject var viewModel = HelperSheetViewModel.shared
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                List {
                    Button("소개화면 다시보기") {
                        viewModel.showWelcomeSheet.toggle()
                    }
                    Button("만든 위젯을 잠금화면에 등록하는 방법") {
                        viewModel.showUseLockscreen.toggle()
                    }
                }
                .listStyle(.insetGrouped)

            }
            .navigationTitle("도움말")
        }
        .tint(.black)
        .welcomeSheet(isPresented: $viewModel.showWelcomeSheet, isSlideToDismissDisabled: true, pages: viewModel.pages)
        .sheet(isPresented: $viewModel.showUseLockscreen) {
            LockscreenHelper()
        }

    }
}

struct HowToUseMenus_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseMenus()
    }
}
