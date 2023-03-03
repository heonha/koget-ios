//
//  Constants.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/30.
//

import Foundation
import SwiftUI

let deviceSize = UIScreen.main.bounds.size
let schemeToAppLink = "link://"
let schemeToOpenLink = "open://"
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
let widgetCellWidthForGrid = deviceSize.width / 4.3

enum Constants {
  static let coreDataContainerName = "WidgetModel"
  static let appGroupID = "group.ZH5GA3W8UP.com.heon.koget"
  static let kogetGradient = LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
  // MARK: - 알수없는 데이터 Placeholder
  static let unknownName = "알수없음"
  static let unknownImage = Image(systemName: "questionmark.circle")
  static let unknownUIImage = UIImage(systemName: "questionmark.circle")!
}

struct CustomFont {
    enum NotoSansKR {
        typealias RawValue = String

        static let light = "NotoSansKR-Light"
        static let regular = "NotoSansKR-Regular"
        static let medium = "NotoSansKR-Medium"
        static let bold = "NotoSansKR-Bold"
    }

    static let sdSwagger = "SDSwagger"
}
