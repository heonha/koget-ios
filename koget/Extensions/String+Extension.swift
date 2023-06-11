//
//  String+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/11.
//

import Foundation

extension String {
    func replaceOnlyAlphabetAndNumbers() -> String {
        return self.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "").replacingOccurrences(of: " ", with: "")
    }
}
