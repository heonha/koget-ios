//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainWidgetViewModel.shared
    @State var isDebugMode = false
    
    var body: some View {
        MainWidgetView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
