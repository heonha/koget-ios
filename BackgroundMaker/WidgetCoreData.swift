//
//  WidgetCoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/11/20.
//


import CoreData
import UIKit
import RxSwift
import RxCocoa

class WidgetCoreData {
    
    static let shared = WidgetCoreData()
    
    var widgets = BehaviorRelay<[DeepLink]>.init(value: [DeepLink]())
    
    private init() {
        loadData()
    }
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    /// AddWidgetVC로 받은 Delegate 프로토콜 메소드입니다.
    func addDeepLinkWidget(widget newWidget: DeepLink) {
        var currentWidgets = widgets.value
        currentWidgets.append(newWidget)
        widgets.accept(currentWidgets)
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
            let deepLink = try coredataContext.fetch(request) // 데이터 가져오기
            self.widgets.accept(deepLink)
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

