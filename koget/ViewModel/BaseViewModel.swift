//
//  BaseViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/04/26.
//

import SwiftUI

enum AppState {
    case none
    case showToast
}

class BaseViewModel: ObservableObject {

    @Published var state: AppState = .none

}
