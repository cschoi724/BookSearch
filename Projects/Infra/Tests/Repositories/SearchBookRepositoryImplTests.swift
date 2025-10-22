//
//  SearchBookRepositoryImplTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra
@testable import Domain

final class SearchBookRepositoryImplTests: XCTestCase {

    private var remote: SearchBookRemoteDataSourceStub!
    private var repo: SearchBookRepository!
    
    override func setUp() {
        super.setUp()
        remote = SearchBookRemoteDataSourceStub()
        repo = SearchBookRepositoryImpl(remote: remote)
    }

    override func tearDown() {
        repo = nil
        remote = nil
        super.tearDown()
    }
    
    // 성공: 정상 JSON -> 도메인 매핑
    func test_mapsDTO_toDomain() async throws {
        remote.nextDTO = MockDTO.searchOK
        let result = try await repo.search(.init(query: "swift", page: 1))

        XCTAssertEqual(result.pageInfo.page, 1)
        XCTAssertEqual(result.pageInfo.total, 20)
        XCTAssertEqual(result.books.count, 2)
        XCTAssertEqual(result.books.first?.title, "SwiftUI in Action")
        XCTAssertEqual(result.books.first?.isbn13, "111")
    }

    // 빈 문서: books=[] -> 빈 결과
    func test_returnsEmpty_whenNoBooks() async throws {
        remote.nextDTO = MockDTO.searchEmpty
        let result = try await repo.search(.init(query: "none", page: 1))

        XCTAssertTrue(result.books.isEmpty)
        XCTAssertEqual(result.pageInfo.page, 1)
        XCTAssertEqual(result.pageInfo.total, 0)
    }

    // 네트워크 오류: NetworkError 그대로 전파
    func test_propagatesNetworkError() async {
        remote.nextError = NetworkError.transport(URLError(.notConnectedToInternet))

        let repo = SearchBookRepositoryImpl(remote: remote)

        do {
            _ = try await repo.search(.init(query: "swift", page: 1))
            XCTFail("에러가 발생해야 한다")
        } catch let error as NetworkError {
            if case .transport = error {
                // OK
            } else {
                XCTFail("NetworkError.transport 여야 함")
            }
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }

    // 전달한 요청 파라미터가 원격으로 그대로 전달된다
    func test_passesRequestToRemote() async throws {
        remote.nextDTO = ItBookSearchResponseDTO(
            error: "0",
            total: "0",
            page: "3",
            books: []
        )

        _ = try await repo.search(.init(query: "swift", page: 3))

        XCTAssertEqual(remote.lastRequest?.query, "swift")
        XCTAssertEqual(remote.lastRequest?.page, 3)
    }
}
