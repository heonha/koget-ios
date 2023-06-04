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

    var sut: SimpleIconService!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetData() {

        // given
        sut.fetchSimpleIcon()

        //when
        let ex = XCTestExpectation(description: "가져온 아이콘이 있어야 합니다.")

        //then
        if sut.simpleIcon.isEmpty {
            XCTFail("가져온 아이콘이 없습니다.")
        } else {
            ex.fulfill()
        }

    }

}
