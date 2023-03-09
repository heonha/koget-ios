//
//  Switcher.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/10.
//

import SwiftUI

class Switcher: ObservableObject {
    
    static let shared = Switcher()
    
    @Published var isTestMode: Bool = false
}
