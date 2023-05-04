//
//  CGRect+Ext.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/05.
//

import Foundation

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
