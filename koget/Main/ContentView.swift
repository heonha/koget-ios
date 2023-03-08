//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI
import UIKit

import SwiftEntryKit

struct ContentView: View {

    @State var isDebugMode = false
    
    var body: some View {
        MainTabView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
