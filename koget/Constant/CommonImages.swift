//
//  CommonImages.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/10.
//

import SwiftUI

struct CommonImages {

    static let unknownError = UIImage(systemName: "exclamationmark.triangle")!.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
    static let koget = UIImage(named: "KogetClear") ?? unknownError
    static let emptyIcon = UIImage(named: "emptyIcon") ?? unknownError

}
