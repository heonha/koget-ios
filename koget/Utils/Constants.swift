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
let GRID_CELL_WIDTH = DEVICE_SIZE.width / 4.3

struct Constants {
    

    static let coreDataContainerName = "WidgetModel"
    static let appGroupID = "group.ZH5GA3W8UP.com.heon.koget"
    static let kogetGradient = LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    //MARK: - 알수없는 데이터 Placeholder
    static let unknownName = "알수없음"
    static let unknownImage = Image(systemName: "questionmark.circle")
    static let unknownUIImage = UIImage(systemName: "questionmark.circle")!

    
}


