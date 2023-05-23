//
//  EntitySaving.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import CoreData

protocol EntitySaving {
    var viewContext: NSManagedObjectContext { get }
    func save()
    func saveSync()
}

extension EntitySaving {
    func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension EntitySaving {
    func saveSync() {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = viewContext
        privateContext.perform {
            do {
                try privateContext.save()
                viewContext.performAndWait {
                    do  {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
