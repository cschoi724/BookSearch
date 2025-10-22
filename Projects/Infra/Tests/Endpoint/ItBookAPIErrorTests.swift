//
//  ItBookAPIErrorTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra

final class ItBookAPIErrorTests: XCTestCase {

    // 플랫폼 에러는 코드값을 포함한 설명을 가진다
    func test_platform_description_containsCode() {
        let error = ItBookAPIError.platform(code: 5, message: nil)
        XCTAssertTrue(error.errorDescription?.contains("5") ?? false)
    }

    // 플랫폼 에러는 커스텀 메시지를 우선 표시한다
    func test_platform_description_usesMessage() {
        let error = ItBookAPIError.platform(code: 2, message: "API 제한 초과")
        XCTAssertEqual(error.errorDescription, "API 제한 초과")
    }

    // unknown 에러는 상태코드를 포함한다
    func test_unknown_description_containsStatusCode() {
        let error = ItBookAPIError.unknown(statusCode: 500)
        XCTAssertTrue(error.errorDescription?.contains("500") ?? false)
    }

    // 동일 타입/코드일 경우 동일하게 비교된다
    func test_equatable() {
        XCTAssertEqual(ItBookAPIError.platform(code: 1, message: nil),
                       ItBookAPIError.platform(code: 1, message: nil))
        XCTAssertNotEqual(ItBookAPIError.unknown(statusCode: 404),
                          ItBookAPIError.unknown(statusCode: 500))
    }
}
