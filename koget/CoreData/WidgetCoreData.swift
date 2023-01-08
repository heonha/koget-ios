//
//  WidgetCoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/20.
//


import SwiftUI
import CoreData

final class WidgetCoreData: ObservableObject {
    
    static let shared = WidgetCoreData()
    
    @Published var linkWidgets = [DeepLink]()
    
    private init() {
        loadData()
    }
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    /// AddWidgetVC로 받은 Delegate 프로토콜 메소드입니다.
    func addDeepLinkWidget(widget newWidget: DeepLink) {
        saveData()
        loadData()
    }
    
    
    func saveData() {
        do {
            try coredataContext.save()
        } catch {
            print("context 저장중 에러 발생 : \(error)")
            fatalError("context 저장중 에러 발생")
        }
    }
    
    
    //원하는 entity 타입의 데이터 불러오기(Read)
    func loadData(sortKey: String = "addedDate", ascending: Bool = false) {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        // 정렬방식 설정
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        
        // 데이터 가져오기
        do {
            linkWidgets = try coredataContext.fetch(request) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            fatalError("데이터 가져오기 에러 발생")
        }
    }
    
    //원하는 entity 타입의 데이터 불러오기(Read)
    func searchData(searchText: String, sortKey: String = "addedDate", ascending: Bool = false) {
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        
        // 정렬방식 설정
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        // 데이터 가져오기
        do {
            linkWidgets = try coredataContext.fetch(request) // 데이터 가져오기
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            fatalError("데이터 가져오기 에러 발생")
        }
    }


    
    func deleteData(data: DeepLink) {
        coredataContext.delete(data)
        saveData()
        loadData()
    }
    
}

