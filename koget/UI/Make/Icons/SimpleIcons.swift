//
//  SimpleIcons.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/05.
//

import Foundation

struct SimpleIcons: Decodable, Identifiable {
    var id: UUID? = UUID()
    let icons: [SimpleIcon]
}

struct SimpleIcon: Decodable {
    let title: String
}
