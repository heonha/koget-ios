//
//  StorageProvider.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/26.
//

import Foundation
import SwiftUI
import CoreData

// Struct Source For russellgordon https://www.russellgordon.ca/tutorials/core-data-and-xcode-previews/

class StorageProvider: ObservableObject {

    let containerName = Constants.COREDATA_CONTAINER_NAME

    @Published private(set) var linkWidgets: [DeepLink] = []

    let persistentContainer: NSPersistentContainer
    
    static var preview: StorageProvider = {
        let storageProvider = StorageProvider(inMemory: true)
        
        let widgets = [
            TestDeepLink(name: "Tmap", image: UIImage(named: "tmap")!.pngData()!, deepLink: "tmap://"),
            TestDeepLink(name: "스타벅스", image: UIImage(named: "starbucks")!.pngData()!, deepLink: "starbucks://"),
            TestDeepLink(name: "Strava", image: UIImage(named: "strava")!.pngData()!, deepLink: "strava://"),
            TestDeepLink(name: "youtube", image: UIImage(named: "youtube")!.pngData()!, deepLink: "https://www.youtube.com"),
                    ]
                    
        for widget in widgets {
            storageProvider.saveData(name: widget.name, image: widget.image, url: widget.deepLink)
        }
        
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        return storageProvider
    }()
    
    init(inMemory: Bool = true) {
        
        // CoreData 모델 파일에 접근
        persistentContainer = NSPersistentContainer(name: Constants.COREDATA_CONTAINER_NAME)
        
        // 메모리에서 실행 중인 경우 나중에 사용할 정보를 저장하지 않음.
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // 영구 저장소 로드 시도(기본 데이터 저장소)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                
                // 현재로서는 모델 로드 실패는 프로그래밍 오류이며 복구할 수 없습니다.
                fatalError("Core Data store failed to load with error: \(error)")
            } else {
                // print("Successfully loaded persistent stores.")
                self.linkWidgets = self.getAllWidgets()
            }
            
        }
    }
    
}

// saveData
extension StorageProvider {
    
    func saveData(name: String, image: Data, url: String) {
        
        let widget = DeepLink(context: persistentContainer.viewContext)
        widget.id = UUID()
        widget.name = name
        widget.image = image
        widget.url = url
        widget.updatedDate = Date()
        
        do {
            try persistentContainer.viewContext.save()
            linkWidgets = getAllWidgets()
        } catch {
            persistentContainer.viewContext.rollback()
        }
        
    }

}

extension StorageProvider {
    
    private func getAllWidgets() -> [DeepLink] {
        let fetchRequest: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()

        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
             print("Failed to fetch Widgets \(error)")
            return []
        }

    }
    
}

struct TestDeepLink {
    let id: UUID = UUID()
    let name: String
    let image: Data
    let deepLink: String
    let updatedDate = Date()
}

extension DeepLink {

    static var example: DeepLink {

        let context = StorageProvider.preview.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        fetchRequest.fetchLimit = 2

        var results: [DeepLink] = []

        do {
            results = try context.fetch(fetchRequest)
        } catch {
            fatalError("fetchRequest Error")
        }
        return results.first!
    }
}
