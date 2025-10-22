//
//  ItBookAPIEndpointTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra
@testable import Domain

final class ItBookAPIEndpointTests: XCTestCase {

    // 검색 요청 시 page 미포함일 때 경로는 /search/{query}
    func test_search_withoutPage() {
        let req = SearchRequest(query: "swift", page: 1)
        let endpoint = ItBookAPIEndpoint.search(request: req)
        XCTAssertEqual(endpoint.path, "/search/swift")
    }

    // 검색 요청 시 page 포함일 때 경로는 /search/{query}/{page}
    func test_search_withPage() {
        let req = SearchRequest(query: "swift", page: 3)
        let endpoint = ItBookAPIEndpoint.search(request: req)
        XCTAssertEqual(endpoint.path, "/search/swift/3")
    }

    // 상세 요청 경로는 /books/{isbn13}
    func test_detail_path() {
        let endpoint = ItBookAPIEndpoint.detail(isbn13: "9781617294136")
        XCTAssertEqual(endpoint.path, "/books/9781617294136")
    }

    // 공통 프로퍼티 검증: method, header, baseURL
    func test_common_properties() {
        let endpoint = ItBookAPIEndpoint.search(request: .init(query: "swift", page: 1))
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.headers["Content-Type"], "application/json")
        XCTAssertEqual(endpoint.baseURL.absoluteString, "https://api.itbook.store/1.0")
    }
}
