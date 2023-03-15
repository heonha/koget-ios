//
//  HelperSheetViewModel.swift
//  koget
//
//  Created by HeonJin Ha on 2023/01/25.
//

import SwiftUI

class HelperSheetViewModel: ObservableObject {

    @Published var showPatchNote = false
    @Published var showUseLockscreen = false
    @Published var showContactView = false
    @Published var showAssetRequestView = false
    @Published var showHowtoUseView = false

    static let shared = HelperSheetViewModel()

    private init() {
    }

}
