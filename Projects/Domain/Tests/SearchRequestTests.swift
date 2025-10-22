//
//  SearchRequestTests.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Domain

final class SearchRequestTests: XCTestCase {

    // SearchRequest의 next()가 page를 1 증가시켜야 한다
    func test_next_incrementsPage() {
        let q1 = SearchRequest(query: "swift", page: 1)
        let q2 = q1.next()
        XCTAssertEqual(q2.query, "swift")
        XCTAssertEqual(q2.page, 2)
    }
}
