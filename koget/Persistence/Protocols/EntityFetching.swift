//
//  EntityFetching.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import CoreData

protocol EntityFetching {
    var viewContext: NSManagedObjectContext { get }
    func fetch<T: NSManagedObject>(predicate: NSPredicate?,
                                    sortDescriptors: [NSSortDescriptor]?,
                                    limit: Int?,
                                    batchSize: Int?) -> [T]
}

extension EntityFetching {
    func fetch<T: NSManagedObject>(predicate: NSPredicate? = nil,
                                    sortDescriptors: [NSSortDescriptor]? = nil,
                                    limit: Int? = nil,
                                    batchSize: Int? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        if let limit = limit, limit > 0 {
            request.fetchLimit = limit
        }

        if let batchSize = batchSize, batchSize > 0 {
            request.fetchBatchSize = batchSize
        }

        do {
            let items = try viewContext.fetch(request)
            return items
        } catch {
            fatalError("Couldnt fetch the enities for \(T.entityName) " + error.localizedDescription)
        }
    }
}
