//
//  ContentView.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var isTesting = false

    var body: some View {
        
        if isTesting {
            // 테스트 뷰
            UploadLinkView()
        } else {
            
            // 일반 뷰
            MainWidgetView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
