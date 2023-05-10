//
//  Constants.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import SwiftUI
import SFSafeSymbols

// App

final class Constants: ObservableObject {

    static let kogetGradient = LinearGradient(colors: [.blue, .red],
                                              startPoint: .topLeading,
                                              endPoint: .bottomTrailing)
    // 알수없는 데이터 Placeholder
    static let unknownName = "알수없음"
    static let unknownImage = Image(systemSymbol: .questionmarkCircle)
    static let unknownUIImage = UIImage(systemSymbol: .questionmarkCircle)
    static let deviceSize = UIScreen.main.bounds.size
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let widgetCellWidthForGrid = deviceSize.width / 4.3
    static let APP_GROUP_ID = "group.ZH5GA3W8UP.com.heon.koget"
    static let COREDATA_CONTAINER_NAME = "WidgetModel"

    

    static let shared = Constants()

    private init() {

    }
}

class AppStateConstant: ObservableObject {

    @AppStorage("isDarkMode") var isDarkMode = false

    static let shared = AppStateConstant()

    private init() {

    }


}
