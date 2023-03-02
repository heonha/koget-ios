//
//  TestDeepLink.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/24.
//

import Foundation
import CoreData

struct TestDeepLink {
    let id: UUID = UUID()
    let name: String
    let image: Data
    let deepLink: String
    let updatedDate = Date()
}

// Exists to provide a movie to use with MovieDetailView and MovieEditView
extension DeepLink {
    
    // Example movie for Xcode previews
    static var example: DeepLink {
        
        // Get the first movie from the in-memory Core Data store
        let context = StorageProvider.preview.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        var results: [DeepLink] = []

        do {
            results = try context.fetch(fetchRequest)
        } catch {
            fatalError("fetchRequest Error")
        }
        return results.first!
    }
}
