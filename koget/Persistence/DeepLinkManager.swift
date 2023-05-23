//
//  DeepLinkManager.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/20.
//

import SwiftUI
import CoreData

class DeepLinkManager: ObservableObject {

    typealias NSPContainer = NSPersistentContainer
    typealias NSPStoreDescription = NSPersistentStoreDescription
    typealias FetchRequest = NSFetchRequest

    static let shared = DeepLinkManager()

    let container = NSPContainer(name: "WidgetModel")
    let coreDataContainerName = Constants.COREDATA_CONTAINER_NAME
    let appGroupID = Constants.APP_GROUP_ID

    @Published var linkWidgets = [DeepLink]()
    @AppStorage("widgetPadding") var widgetPadding = 1.0

    private init() {
        loadStore()
        loadData()
    }

    private func loadStore() {
        let storeURL = URL.storeURL(for: appGroupID, databaseName: coreDataContainerName)
        let storeDescription = NSPStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDesc, error) in
            if let error = error as NSError? {
                debugPrint("PersistentStore Load Error: \(error.localizedDescription)")
                return
            }
        })
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

        let sortedRequest = sortedRequest(sortKey: sortKey)

        do {
            linkWidgets = try container.viewContext.fetch(sortedRequest) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            return
        }
    }

    func loadData(sortKey: WidgetSortKeys, ascending: Bool = false) {

        let sortedRequest = sortedRequest(sortKey: sortKey, ascending: ascending)

        do {
            linkWidgets = try container.viewContext.fetch(sortedRequest) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            return
        }

    }

    //원하는 entity 타입의 데이터 불러오기(Read)
    func searchData(searchText: String, sortKey: WidgetSortKeys = .updatedDate, ascending: Bool = false) {

        let sortedRequest = sortedRequest(searchText: searchText, sortKey: sortKey)

        // 데이터 가져오기
        do {
            linkWidgets = try container.viewContext.fetch(sortedRequest) // 데이터 가져오기
        } catch {
             print("데이터 가져오기 에러 발생 : \(error)")
            return
        }
    }

    private func sortedRequest(searchText: String = "", format: String = "name CONTAINS[cd] %@" , sortKey: WidgetSortKeys, ascending: Bool = false) -> FetchRequest<DeepLink> {

        let request: FetchRequest<DeepLink> = DeepLink.fetchRequest()

        let predicate = NSPredicate(format: format, searchText)

        let sortDescriptor = NSSortDescriptor(key: sortKey.rawValue, ascending: ascending)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]

        return request
    }

    func deleteData(data: DeepLink) {
        container.viewContext.delete(data)
        saveData()
        loadData()
    }

}
