//
//  URL+Extension.swift
//  koget
//
//  Created by Heonjin Ha on 2023/05/16.
//

import SwiftUI
import CoreData

extension URL {
    /// sqlite 데이터베이스를 가리키는 지정된 앱 그룹 및 데이터베이스의 URL을 반환합니다.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("공유 파일 컨테이너를 생성할 수 없습니다. : Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
