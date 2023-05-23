//
//  NSManagedObject+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import CoreData

extension NSManagedObject {
    class var entityName: String {
        return String(describing: self)
                    .components(separatedBy: ".").last!
    }
}
