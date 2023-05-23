//
//  CoreDataStore.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/23.
//

import CoreData

enum StorageType {
    case persistent, inMemory
}

protocol CoreDataStoring: EntityCreating, EntitySaving, EntityFetching {
    var viewContext: NSManagedObjectContext { get }
    func save()
}

class CoreDataStore: CoreDataStoring {

    private let container: NSPersistentContainer

    static var `default`: CoreDataStoring = {
        return CoreDataStore(name: "WidgetModel", in: .persistent)
    }()

    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }

    init(name: String, in storageType: StorageType) {
        self.container = NSPersistentContainer(name: name)
        self.setupIfMemoryStorage(storageType)
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    private func setupIfMemoryStorage(_ storageType: StorageType) {
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
}
