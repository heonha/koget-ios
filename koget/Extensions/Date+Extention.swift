//
//  Date+Extention.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/10.
//

import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
