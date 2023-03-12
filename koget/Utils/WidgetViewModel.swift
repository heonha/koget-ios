//
//  WidgetViewModel.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/13.
//

import SwiftUI

final class WidgetViewModel: ObservableObject {

    @Published var size: Double = 1.0

    static let shared = WidgetViewModel()

    private init() {

    }
}
