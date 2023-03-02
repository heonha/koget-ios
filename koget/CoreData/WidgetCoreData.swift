//
//  WidgetCoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/20.
//

import SwiftUI
import CoreData

class WidgetCoreData: ObservableObject {
    
    static let shared = WidgetCoreData()
    
    @Published var linkWidgets = [DeepLink]()
    @Published var lastUpdatedDate = Date()
    @Published var lastSelectedWidget: DeepLink?
    var container = NSPersistentContainer(name: Constants.coreDataContainerName)
    
    private init() {

        let storeURL = URL.storeURL(for: Constants.appGroupID, databaseName: Constants.coreDataContainerName)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("해결되지 않은 오류 Unresolved error : \(error), \(error.userInfo)")
            }
        })
        
        loadData()
    }
    
    func addLinkWidget(name: String, image: UIImage?, url: String, opacity: Double = 0.7) {
        let widget = DeepLink(context: container.viewContext)
        widget.id = UUID()
        widget.name = name
        widget.image = image?.pngData()
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = (opacity) as NSNumber
        
        saveData()
        loadData()
    }

    func editLinkWidget(name: String, image: UIImage?, url: String, opacity: Double, widget: DeepLink) {
        
        widget.name = name
        if widget.image != image?.pngData() {
            widget.image = image?.pngData()
        }
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = (opacity) as NSNumber
        
        saveData()
        loadData()
    }
    
    func getStoredDataForDeepLink() -> [DeepLink]? {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        do {
            let deepLinks = try container.viewContext.fetch(request) // 데이터 가져오기
            
            return deepLinks
            
        } catch {
            // print("데이터 가져오기 에러 발생 : \(error)")
        }
        return nil
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            // print("저장완료")
        } catch {
            // print("context 저장중 에러 발생 : \(error)")
            fatalError("context 저장중 에러 발생")
        }
    }
    
    enum WidgetSortKeys: String {
        case updatedDate = "updatedDate"
        case runCount = "runCount"
    }
    
    func loadData(sortKey: WidgetSortKeys = .runCount, ascending: Bool = false) {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        // 정렬방식 설정
        let sortDescriptor = NSSortDescriptor(key: sortKey.rawValue, ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        
        // 데이터 가져오기
        do {
            linkWidgets = try container.viewContext.fetch(request) // 데이터 가져오기
            self.objectWillChange.send()
            // print("로드완료")
        } catch {
            // print("데이터 가져오기 에러 발생 : \(error)")
            fatalError("데이터 가져오기 에러 발생")
        }
    }
    
    //원하는 entity 타입의 데이터 불러오기(Read)
    func searchData(searchText: String, sortKey: String = "updatedDate", ascending: Bool = false) {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        
        // 정렬방식 설정
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        // 데이터 가져오기
        do {
            linkWidgets = try container.viewContext.fetch(request) // 데이터 가져오기
        } catch {
            // print("데이터 가져오기 에러 발생 : \(error)")
            fatalError("데이터 가져오기 에러 발생")
        }
    }

    func deleteData(data: DeepLink) {
        container.viewContext.delete(data)
        saveData()
        loadData()
    }
}

public extension URL {
    /// sqlite 데이터베이스를 가리키는 지정된 앱 그룹 및 데이터베이스의 URL을 반환합니다.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("공유 파일 컨테이너를 생성할 수 없습니다. : Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
