//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import SwiftUI

final class LinkWidgetModel: ObservableObject {
    
    @Published var widgetName: String = ""
    @Published var widgetURL: String = ""
    @Published var widgetImage: UIImage?
        
    func getWidgetData(selectedWidget: LinkWidget) {
        self.widgetName = selectedWidget.appNameGlobal
        self.widgetURL = selectedWidget.deepLink + "://"
        self.widgetImage = selectedWidget.image!
    }
    

    
}
