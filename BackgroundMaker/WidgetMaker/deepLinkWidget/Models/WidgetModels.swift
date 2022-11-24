//
//  WidgetModels.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/23.
//

import UIImageColors
import UIKit
import SwiftUI
import RxSwift

final class WidgetModels: ObservableObject {
    
    @Published var widgets: [DeepLink] = WidgetCoreData.shared.widgets.value
    @Published var widgetName: String = ""
    @Published var widgetURL: String = ""
    @Published var widgetImage: UIImage?
        
    func getWidgetData(selectedWidget: BuiltInDeepLink) {
        self.widgetName = selectedWidget.appNameGlobal
        self.widgetURL = selectedWidget.deepLink + "://"
        self.widgetImage = selectedWidget.image!
    }
    

    
}
