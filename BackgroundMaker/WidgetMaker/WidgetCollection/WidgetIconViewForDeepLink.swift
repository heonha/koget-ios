//
//  WidgetIconViewForDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import SwiftUI

struct WidgetIconView: View {
    
    let image: UIImage
    let name: String
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            Text(name)
                .lineLimit(2)
                .font(.system(size: 13))
        }.frame(width: 70, height: 80)
    }
}


struct DeepLinkWidgetIconView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetIconView(image: UIImage.init(named: "TestWidgetImage")!, name: "테스트")
    }
}
