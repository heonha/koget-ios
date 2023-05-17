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

    @AppStorage("widgetPadding") var widgetPadding = 1.0
    @Published var linkWidgets = [DeepLink]()
    @Published var lastUpdatedDate = Date()
    @Published var lastSelectedWidget: DeepLink?
    let container = NSPersistentContainer(name: "WidgetModel")
    let coreDataContainerName = Constants.COREDATA_CONTAINER_NAME
    let appGroupID = Constants.APP_GROUP_ID

    private init() {

        let storeURL = URL.storeURL(for: appGroupID, databaseName: coreDataContainerName)
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
        widget.image = compressPNGData(with: image)
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = (opacity) as NSNumber

        linkWidgets.append(widget)
        saveData()
        loadData()
    }

    func compressPNGData(with image: UIImage?) -> Data {

        // 새로운 이미지 크기 설정
        let newSize = CGSize(width: 128, height: 128)

        // 그래픽 컨텍스트 생성
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // PNG 데이터 생성
        if let imageData = newImage?.pngData() {
            return imageData
        } else {
            return Data()
        }
    }

    func editLinkWidget(name: String, image: UIImage?, url: String, opacity: Double, widget: DeepLink) {
        
        widget.name = name
        if widget.image != image?.pngData() {
            widget.image = compressPNGData(with: image)
        }
        widget.url = url
        widget.updatedDate = Date()
        widget.opacity = NSNumber(floatLiteral: opacity)
        saveData()
        loadData()
    }
    
    func getStoredDataForDeepLink() -> [DeepLink]? {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        do {
            let deepLinks = try container.viewContext.fetch(request) // 데이터 가져오기
            
            return deepLinks
            
        } catch {

        }
        return nil
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
            return
        }
    }
    
    enum WidgetSortKeys: String {
        case updatedDate = "updatedDate"
        case runCount = "runCount"
        case index = "index"
    }
    
    func loadData(sortKey: WidgetSortKeys = .index) {
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            linkWidgets = try container.viewContext.fetch(request) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            return
        }
    }

    func loadData(sortKey: WidgetSortKeys, ascending: Bool = false) {

        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: sortKey.rawValue, ascending: ascending)
        request.sortDescriptors = [sortDescriptor]

        do {
            linkWidgets = try container.viewContext.fetch(request) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            return
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
