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

    let appGroupID = Constants.APP_GROUP_ID

    @Published var linkWidgets = [DeepLink]()
    @AppStorage("widgetPadding") var widgetPadding = 1.0

    let coreDataStore: CoreDataStoring

    init(coreDataStore: CoreDataStoring = CoreDataStore(name: "WidgetModel", in: .persistent)) {
        self.coreDataStore = coreDataStore
        self.loadData()
    }

}

extension DeepLinkManager {

    func saveData() {
        coreDataStore.save()
    }

    func loadData(sortKey: WidgetSortKeys = .index) {
        let context = coreDataStore.viewContext
        let fetchRequest: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()

        do {
            linkWidgets = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching DeepLinks: \(error)")
        }
    }

    func loadData(sortKey: WidgetSortKeys, ascending: Bool = false) {
        let context = coreDataStore.viewContext
        let sortedRequest = sortedRequest(sortKey: sortKey, ascending: ascending)

        do {
            linkWidgets = try context.fetch(sortedRequest) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            return
        }

    }

    func searchData(searchText: String, sortKey: WidgetSortKeys = .updatedDate, ascending: Bool = false) {
        let context = coreDataStore.viewContext

        let sortedRequest = sortedRequest(searchText: searchText, sortKey: sortKey)

        do {
            linkWidgets = try context.fetch(sortedRequest) // 데이터 가져오기
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
        let context = coreDataStore.viewContext
        context.delete(data)
        saveData()
        loadData()
    }

}
