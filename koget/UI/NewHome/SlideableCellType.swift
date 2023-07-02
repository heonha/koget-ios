//
//  SlideableCellType.swift
//  koget
//
//  Created by HeonJin Ha on 2023/06/27.
//

import SwiftUI

enum SlideableButtonType: String {
    case edit
    case delete
    
    func getBackgroundColor() -> Color {
        switch self {
        case .edit:
            return Color(hex: "FFE4A7")
        case .delete:
            return Color(hex: "FEA1A1")
        }
    }
    
    func getSymbolName() -> String {
        switch self {
        case .edit:
            return "slider.horizontal.3"
        case .delete:
            return "xmark.octagon.fill"
        }
    }
}
