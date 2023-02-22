//
//  LocalizationExtensions.swift
//  koget
//
//  Created by Heonjin Ha on 2023/02/22.
//

import SwiftUI

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
}

extension String {
    static func localizedString(_ key: String, locale: Locale = .current) -> String {
        
        let language = Locale.current.language.languageCode?.identifier
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        return localizedString
        

        
    }
}

extension LocalizedStringKey {
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(self.stringKey ?? "?", locale: locale)
    }
}
