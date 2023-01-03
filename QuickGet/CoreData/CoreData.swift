//
//  CoreData.swift
//  BackgroundMaker
//
//  Created by HeonJin Ha on 2022/10/14.
//

import CoreData

class CoreData {
    
    private init() {
        
    }
    
    static let shared = CoreData()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         애플리케이션의 Persistent Container 입니다.
         이 구현은 애플리케이션 저장소를 로드한 컨테이너를 생성하고 반환합니다.
         저장소 생성에 실패할 수 있는 합법적인 오류 조건이 있으므로 이 속성은 Optional 입니다.
         */
        let storeURL = URL.storeURL(for: Constants.appGroupID, databaseName: Constants.coreDataEntityName)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: Constants.coreDataEntityName)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 // 이 구현을 코드로 교체하여 오류를 적절하게 처리하십시오.
                 // fatalError() 는 응용 프로그램이 충돌 로그를 생성하고 종료하도록 합니다.
                 // 개발 중에 유용할 수 있지만 배송 애플리케이션에서는 이 기능을 사용해서는 안 됩니다.

                /*

                 여기에 오류가 발생하는 일반적인 이유는 다음과 같습니다.
                 * 상위 디렉토리가 존재하지 않거나 생성할 수 없거나 쓰기가 허용되지 않습니다.
                 * 장치가 잠겨 있을 때 권한 또는 데이터 보호로 인해 영구 저장소에 액세스할 수 없습니다.
                 * 장치의 공간이 부족합니다.
                 * 스토어를 현재 모델 버전으로 마이그레이션할 수 없습니다.
                 오류 메시지를 확인하여 실제 문제가 무엇인지 확인하십시오.
                 */
                
                fatalError("해결되지 않은 오류 Unresolved error : \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // func getStoredDataFromCoreData() {
    //     let managedContext = persistentContainer.viewContext
    //
    //     let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreDataEntityName)
    //     do {
    //         try managedContext.fetch(fetchRequest)
    //         //EntityName에 저장된 모든 결과를 반복합니다.
    //         // for data in result {
    //         //     // 저장된 데이터로 작업 수행
    //         //
    //         // }
    //     } catch let error as NSError {
    //         // 이 구현을 코드로 교체하여 오류를 적절하게 처리하십시오.
    //         // fatalError() 는 응용 프로그램이 충돌 로그를 생성하고 종료하도록 합니다.
    //         // 개발 중에 유용할 수 있지만 배송 애플리케이션에서는 이 기능을 사용해서는 안 됩니다.
    //         let nserror = error as NSError
    //         fatalError("해결되지 않은 오류 Unresolved error : \(nserror), \(nserror.userInfo)")
    //     }
    // }
    
    func getStoredDataForDeepLink() -> [DeepLink]? {
        let coredataContext = persistentContainer.viewContext
        
        let request: NSFetchRequest<DeepLink> = DeepLink.fetchRequest()
        do {
            let deepLinks = try coredataContext.fetch(request) // 데이터 가져오기
            
            return deepLinks
            
        } catch let error {
            print("데이터 가져오기 에러 발생 : \(error)")
        }
        return nil
    }
    

    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // 이 구현을 코드로 교체하여 오류를 적절하게 처리하십시오.
                // fatalError() 는 응용 프로그램이 충돌 로그를 생성하고 종료하도록 합니다.
                // 개발 중에 유용할 수 있지만 배송 애플리케이션에서는 이 기능을 사용해서는 안 됩니다.
                let nserror = error as NSError
                fatalError("해결되지 않은 오류 : Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
