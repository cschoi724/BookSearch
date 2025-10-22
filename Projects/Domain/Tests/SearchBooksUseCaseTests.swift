//
//  SearchBooksUseCaseTests.swift
//  Domain
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Domain

final class SearchBooksUseCase_CursoryTests: XCTestCase {

    // 검색 유즈케이스가 레포지토리를 올바르게 호출하고 결과를 반환해야 한다
    func test_search_returnsResult() async throws {
        let repo = MockSearchBookRepository()
        let items = [
            BookItem(title: "A", subtitle: nil, isbn13: "1", price: "$0", image: nil, url: nil),
            BookItem(title: "B", subtitle: "b", isbn13: "2", price: "Free", image: "img", url: "u")
        ]
        let pageInfo = PageInfo(page: 1, total: 25)
        repo.result = SearchResult(pageInfo: pageInfo, books: items)

        let useCase = DefaultSearchBooksUseCase(repository: repo)
        let query = SearchRequest(query: "swift", page: 1)

        let result = try await useCase(query)

        XCTAssertEqual(repo.lastQuery, query, "리포지토리에 동일한 쿼리를 전달해야 함")
        XCTAssertEqual(result.pageInfo.page, 1)
        XCTAssertEqual(result.pageInfo.total, 25)
        XCTAssertEqual(result.books.count, 2)
    }
    
    // 검색 유즈케이스가 레포지토리 에러를 그대로 전달해야 한다
    func test_search_throwsRepositoryError() async throws {
        enum DummyError: Error { case networkFailed }
        let repo = MockSearchBookRepository()
        repo.error = DummyError.networkFailed

        let useCase = DefaultSearchBooksUseCase(repository: repo)
        let query = SearchRequest(query: "swift", page: 1)

        do {
            _ = try await useCase(query)
            XCTFail("에러가 발생해야 합니다.")
        } catch {
            guard case DummyError.networkFailed = error else {
                XCTFail("예상과 다른 에러가 발생했습니다: \(error)")
                return
            }
        }
    }
}
