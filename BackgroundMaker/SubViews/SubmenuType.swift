//
//  SubmenuType.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/09/29.
//

import Foundation
import UIKit

enum SubmenuType {
    case none
    case blur
    case editBackground
    case save
    case share
}

class SubmenuButton: UIButton {
    
    var stp: SubmenuType?
    
}
