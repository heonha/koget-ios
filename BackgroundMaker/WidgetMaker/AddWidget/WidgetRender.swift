//
//  WidgetRender.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/11.
//

import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct WidgetRender: View {
    
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var body: some View {
        ZStack {
            Image("mainBG")
                .resizable()
                .aspectRatio(contentMode: .fit)
            // Label("Flag", systemImage: "flag.fill")
            //     .padding()
            //     .background(.bar)
            Image(systemName: "crop")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .symbolVariant(.slash)
                .padding()
                .background(.regularMaterial)
        }
    }
}

@available(iOS 16.0, *)
struct WidgetRender_Previews: PreviewProvider {
    static var previews: some View {
        WidgetRender()
    }
}
