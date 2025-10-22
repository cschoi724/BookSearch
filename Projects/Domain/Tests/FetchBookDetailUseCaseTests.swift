//
//  FetchBookDetailUseCaseTests.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Domain

final class FetchBookDetailUseCaseTests: XCTestCase {

    // 상세 유즈케이스가 레포지토리를 올바르게 호출하고 결과를 반환해야 한다
    func test_fetch_returnsDetail() async throws {
        let repo = MockBookDetailRepository()
        repo.result = BookDetail(
            title: "Swift", subtitle: "Guide",
            authors: "Apple", publisher: "Apple",
            language: "EN", isbn10: "1234567890", isbn13: "9780000000000",
            pages: 500, year: "2024", rating: 4,
            desc: "desc", price: "$44.99", image: "img", url: "u", pdfs: []
        )

        let useCase = DefaultFetchBookDetailUseCase(repository: repo)
        let detail = try await useCase(isbn13: "9780000000000")

        XCTAssertEqual(repo.lastISBN, "9780000000000", "리포지토리에 동일한 ISBN13을 전달해야 함")
        XCTAssertEqual(detail.isbn13, "9780000000000")
        XCTAssertEqual(detail.title, "Swift")
    }
    
    // 상세 유즈케이스가 레포지토리 에러를 그대로 전달해야 한다
    func test_fetch_throwsRepositoryError() async throws {
        enum DummyError: Error { case notFound }
        let repo = MockBookDetailRepository()
        repo.error = DummyError.notFound

        let useCase = DefaultFetchBookDetailUseCase(repository: repo)
        do {
            _ = try await useCase(isbn13: "9780000000000")
            XCTFail("에러가 전달되어야 함")
        } catch {
            guard case DummyError.notFound = error else {
                XCTFail("다른 에러가 발생했습니다: \(error)")
                return
            }
        }
    }
}
