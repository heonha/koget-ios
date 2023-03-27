//
//  Constants.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import SwiftUI
import SFSafeSymbols

// App
let deviceSize = UIScreen.main.bounds.size
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
let widgetCellWidthForGrid = deviceSize.width / 4.3
let APP_GROUP_ID = "group.ZH5GA3W8UP.com.heon.koget"
let COREDATA_CONTAINER_NAME = "WidgetModel"

final class Constants: ObservableObject {

//    let coreDataContainerName = "WidgetModel"
    // CoreData
    static let kogetGradient = LinearGradient(colors: [.blue, .red],
                                              startPoint: .topLeading,
                                              endPoint: .bottomTrailing)
    // 알수없는 데이터 Placeholder
    static let unknownName = "알수없음"
    static let unknownImage = Image(systemSymbol: .questionmarkCircle)
    static let unknownUIImage = UIImage(systemSymbol: .questionmarkCircle)
    
    @AppStorage("isDarkMode") var isDarkMode = false

    static let shared = Constants()

    private init() {

    }
}
