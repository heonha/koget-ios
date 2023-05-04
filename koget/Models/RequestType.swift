//
//  RequestType.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/19.
//

import Foundation

enum RequestReturnType {
    case success
    case userError
    case serverError
}

enum ResultType {
    case success
    case error
}

enum MakeResultType {
    case success
    case emptyFieldError
    case missingSchemeError
}
