//
//  CoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/14.
//

import Foundation
import CoreData

class CoreData {
    
    private init() {
        
    }
    
    static let shared = CoreData()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let storeURL = URL.storeURL(for: Constants.appGroupID, databaseName: Constants.coreDataEntityName)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: Constants.coreDataEntityName)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getStoredDataFromCoreData() {
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreDataEntityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            //EntityName에 저장된 모든 결과를 반복합니다.
            for data in result {
                // 저장된 데이터로 작업 수행
                
            }
        } catch let error as NSError {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getStoredDataForDeepLink() -> [DeepLink]? {
        let coredataContext = persistentContainer.viewContext
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        do {
            let deepLinks = try coredataContext.fetch(request) // 데이터 가져오기
            
            return deepLinks
            
        } catch let error {
            print("데이터 가져오기 에러 발생 : \(error)")
        }
        return nil
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
