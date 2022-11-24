//
//  TestCoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import Foundation
import SwiftUI


struct TestDeepLink {
    let id: UUID = UUID()
    let name: String?
    let image: Data?
    let deepLink: String?
    let addedDate = Date()
}

struct TestCoreData {
    
    @State var deepLinkWidgets: [TestDeepLink] = [
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),
        TestDeepLink(name: "Test", image: UIImage(named: "TEST_Image_Widget")!.pngData()!, deepLink: "no url"),

        
    ]
    
    
    func getDeepLinkItem() -> DeepLink {
        let item = DeepLink(context: WidgetCoreData.shared.coredataContext)
        item.id = UUID()
        item.name = "TestName"
        item.image = UIImage(systemName: "widgetTestImage")!.pngData()
        item.deepLink = "https://www.naver.com"
        item.addedDate = Date()
        return item
    }
    
    
}
