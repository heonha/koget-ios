//
//  PatchNote.swift
//  koget
//
//  Created by Heonjin Ha on 2023/06/03.
//

import Foundation

struct PatchNote: Codable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let subtitle: String
    let lightFileName: String
    let darkFileName: String
    let date: Date
}
