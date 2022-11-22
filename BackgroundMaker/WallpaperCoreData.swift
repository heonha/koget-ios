//
//  WallpaperCoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/30.
//

import CoreData
import UIKit

class WallpaperCoreData {
    
    static let shared = WallpaperCoreData()
    
    var wallpapers = [Wallpaper]()
    
    private init() {
        loadData { [weak self] (wallpapers) in
            self?.wallpapers = wallpapers
        }
    }
    
    let coredataContext = CoreData.shared.persistentContainer.viewContext
    
    func saveData() {
        do {
            try coredataContext.save()
        } catch {
            print("context 저장중 에러 발생 : \(error)")
            fatalError("context 저장중 에러 발생")

        }
    }
    
    //원하는 entity 타입의 데이터 불러오기(Read)
    func loadData(sortKey: String = "createdDate", ascending: Bool = false, completion: @escaping ([Wallpaper]) -> Void) {
        
        let request: NSFetchRequest<Wallpaper> = Wallpaper.fetchRequest()
        // 정렬방식 설정
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
        request.sortDescriptors = [sortDescriptor]
        
        // 데이터 가져오기
        do {
            let wallpapers = try coredataContext.fetch(request) // 데이터 가져오기
            completion(wallpapers)
        } catch {
            print("데이터 가져오기 에러 발생 : \(error)")
            fatalError("데이터 가져오기 에러 발생")
        }
    }

    
    func deleteData(data: Wallpaper) {
        coredataContext.delete(data)
        saveData()
        loadData { [weak self] (wallpapers) in
            self?.wallpapers = wallpapers
        }
        
    }
    
}

