//
//  SimpleIconTests.swift
//  kogetTests
//
//  Created by Heonjin Ha on 2023/06/04.
//

import SwiftUI
import Combine
import SVGKit
import XCTest
@testable import koget

final class SimpleIconTests: XCTestCase {

    var sut: SimpleIconManager!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetData() {

        let iconName = "swift"

        sut.searchIcon(name: iconName)

        let ex = XCTestExpectation(description: "가져온 아이콘이 있어야 합니다.")

        if sut.simpleIcon.isEmpty {
            XCTFail("가져온 아이콘이 없습니다.")
        } else {
            ex.fulfill()
        }

    }

}
