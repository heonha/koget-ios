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

// Enviroment를 통과하려면 ObservableObject를 준수해야 합니다.
class StorageProvider: ObservableObject {
    
    // DeepLink 목록
    @Published private(set) var linkWidgets: [DeepLink] = []

    // Core Data 스택 초기화 및 Core Data 모델 파일 로드
    let persistentContainer: NSPersistentContainer
    
    // Xcode 미리보기와 함께 사용하기 위해 예제를 위해 작업할 일부 데이터를 제공합니다.
    static var preview: StorageProvider = {
        
        // 메모리에서만 실행되는 공급자의 인스턴스를 만듭니다.
        let storageProvider = StorageProvider(inMemory: true)
        
        // 테스트 동영상 몇 개 추가
        let widgets = [
            TestDeepLink(name: "스타벅스", image: UIImage(named: "starbucks")!.pngData()!, deepLink: "starbucks://"),
            TestDeepLink(name: "Strava", image: UIImage(named: "strava")!.pngData()!, deepLink: "strava://"),
            TestDeepLink(name: "Tmap", image: UIImage(named: "tmap")!.pngData()!, deepLink: "tmap://"),
            TestDeepLink(name: "youtube", image: UIImage(named: "youtube")!.pngData()!, deepLink: "https://www.youtube.com"),
                    ]
                    
        for widget in widgets {
            storageProvider.saveData(name: widget.name, image: widget.image, url: widget.deepLink)
        }
        
        // 위 데이터를 Core Data 저장소에 저장합니다.
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            // 문제가 발생 시 Crash 😭
            // print("Failed to save test movies: \(error)")
        }

        return storageProvider
    }()
    
    init(inMemory: Bool = true) {
        
        // CoreData 모델 파일에 접근
        persistentContainer = NSPersistentContainer(name: Constants.coreDataContainerName)
        
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
        
        // 새 Entity 인스턴스는 관리 개체 컨텍스트에 연결됩니다.
        let widget = DeepLink(context: persistentContainer.viewContext)
        
        // Set the name for the new movie
        widget.id = UUID()
        widget.name = name
        widget.image = image
        widget.url = url
        widget.updatedDate = Date()
        
        do {
            
            // Persist the data in this managed object context to the underlying store
            try persistentContainer.viewContext.save()
            // print("saved successfully")
            // Refresh
            linkWidgets = getAllWidgets()
            
        } catch {
            // Something went wrong 😭
            // print("Failed to save data: \(error)")
            // 관리 개체 컨텍스트의 모든 변경 사항을 롤백합니다.
            persistentContainer.viewContext.rollback()
            
        }
        
    }

}

// Get all the Data
extension StorageProvider {
    
    // View는 StorageProvider의 배열을 통해 Core Data에서 검색된 데이터에 액세스하므로 비공개로 설정됩니다.
    private func getAllWidgets() -> [DeepLink] {
        // 주석으로 유형을 지정해야 합니다. 그렇지 않으면 Xcode는 사용할 fetchRequest()의 오버로드를 알 수 없습니다(엔터티용으로 사용하려고 함).
        // 일반적인 인수 <EntityName>는 Swift가 fetchRequest가 반환하는 관리 객체의 종류를 알 수 있도록 하여 영화 목록을 배열로 반환하는 것을 더 쉽게 만듭니다.
        let fetchRequest: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        
        do {
            
            // Return an array of Movie objects, retrieved from the Core Data store
            return try persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            // print("Failed to fetch Widgets \(error)")
        }
        
        // 오류가 발생하면 아무 것도 반환하지 않음
        return []
    }
    
}
