//
//  Constants.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import Foundation
import SwiftUI

let DEVICE_SIZE = UIScreen.main.bounds.size
let SCHEME_LINK = "link://"
let SCHEME_OPEN = "open://"
let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String


struct Constants {
    

    static let coreDataContainerName = "WidgetModel"
    static let appGroupID = "group.ZH5GA3W8UP.com.heon.koget"
    static let kogetGradient = LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)

    
}


