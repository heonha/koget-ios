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
    lazy var context = coreDataStore.viewContext


    @Published var linkWidgets = [DeepLink]()
    @AppStorage("sortKey") var sortKey: WidgetSortKeys = .runCount

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

    func loadData(sortKey: WidgetSortKeys? = nil,
                  ascending: Bool = false) {

        var sortKey: WidgetSortKeys?

        if sortKey == nil {
            sortKey = self.sortKey
        }

        linkWidgets = sortedRequest(sortKey: sortKey, ascending: ascending)
    }

    func searchData(searchText: String, sortKey: WidgetSortKeys = .updatedDate, ascending: Bool = false) {

        linkWidgets = sortedRequest(searchText: searchText, format: "name CONTAINS[cd] %@", sortKey: sortKey)

    }

    func deleteData(data: DeepLink) {
        coreDataStore.viewContext.delete(data)
        saveData()
        loadData()
    }

    private func sortedRequest(searchText: String = "",
                               format: String? = nil,
                               sortKey: WidgetSortKeys?,
                               ascending: Bool = false) -> [DeepLink] {

        var predicate: NSPredicate?

        if let format = format {
            predicate = NSPredicate(format: format, searchText)
        }

        let sortDescriptor = NSSortDescriptor(key: sortKey?.rawValue, ascending: ascending)

        return coreDataStore.fetch(predicate: predicate,
                                   sortDescriptors: [sortDescriptor],
                                   limit: nil,
                                   batchSize: nil)
    }

}
