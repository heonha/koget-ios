//
//  NetworkServiceTests.swift
//  kogetTests
//
//  Created by Heonjin Ha on 2023/06/04.
//

import Combine
import XCTest
@testable import koget

final class NetworkServiceTests: XCTestCase {

    var sut: NetworkService!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetSuccess() {

        // given


        // when
        let expectation1 = XCTestExpectation(description: "HTTP Response가 200 을 리턴합니다.")
        let expectation2 = XCTestExpectation(description: "데이터를 정상적으로 가져옵니다.")
    }

    func testGetFailure() {

        // given
        let baseURL = URL(string: "https://cdn.simpleicons.org/")
        let iconName = "1i3enfklsm"

        // when
        let expectation = XCTestExpectation(description: "HTTP Response가 실패를 반환합니다.")
        let expectation2 = XCTestExpectation(description: "실패 Response message를 출력합니다.")

        // then

    }

}
