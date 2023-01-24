//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MainWidgetViewModel.shared
    
    var body: some View {
        
            // 일반 뷰
            MainWidgetView(viewModel: viewModel)
            .fullScreenCover(isPresented: $viewModel.isFirstRun) {
                OnboardingPageView()
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
