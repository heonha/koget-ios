//
//  ContactType.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/19.
//

import Foundation

enum ContectType: String {
    case app
    case addApp
    case feedback
    case etc
    case none

    var localizedDescription: String {
        switch self {
        case .app:
            return S.ContactType.problemApp
        case .addApp:
            return S.ContactType.requestApp
        case .feedback:
            return S.ContactType.feedback
        case .etc:
            return S.ContactType.etc
        case .none:
            return S.ContactType.select
        }
    }

}
