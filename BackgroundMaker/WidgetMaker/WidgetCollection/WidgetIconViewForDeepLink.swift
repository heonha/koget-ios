//
//  WidgetIconViewForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI
import CoreData

struct WidgetIconView: View {
    
    @ObservedObject var selectedObject: DeepLink
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data:selectedObject.image!)
                  ?? UIImage(named: "qustionmark.circle")!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Text(selectedObject.name!)
                .lineLimit(2)
                .font(.system(size: 13))
        }.frame(width: 70, height: 80)
    }
}


struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetIconView(selectedObject: DeepLink.example)
    }
}
