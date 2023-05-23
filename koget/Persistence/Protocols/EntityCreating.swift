//
//  EntityCreating.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import CoreData

protocol EntityCreating {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension EntityCreating {
    func createEntity<T: NSManagedObject>() -> T {
        return T(context: viewContext)
    }
}
