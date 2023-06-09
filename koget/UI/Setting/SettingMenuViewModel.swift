//
//  HelperSheetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/25.
//

import SwiftUI

class SettingMenuViewModel: BaseViewModel {

    @Published var showPatchNote = false
    @Published var showUseLockscreen = false
    @Published var showContactView = false
    @Published var showAssetRequestView = false
    @Published var showHowtoUseView = false
    @Published var showLicenseView = false

    static let shared = SettingMenuViewModel()

    private override init() {
        super.init()
    }

}
