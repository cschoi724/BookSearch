//
//  BookDetailRepositoryImplTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra
@testable import Domain

final class BookDetailRepositoryImplTests: XCTestCase {

    private var remote: BookDetailRemoteDataSourceStub!
    private var repo: BookDetailRepository!

    override func setUp() {
        super.setUp()
        remote = BookDetailRemoteDataSourceStub()
        repo = BookDetailRepositoryImpl(remote: remote)
    }

    override func tearDown() {
        repo = nil
        remote = nil
        super.tearDown()
    }

    // 성공: 정상 JSON -> 도메인 매핑
    func test_mapsDTO_toDomain() async throws {
        remote.nextDTO = MockDTO.detailOK

        let detail = try await repo.fetchBookDetail(isbn13: "9781617294136")

        XCTAssertEqual(detail.title, "Securing DevOps")
        XCTAssertEqual(detail.isbn13, "9781617294136")
        XCTAssertEqual(detail.pdfs.count, 2)
    }

    // 네트워크 오류: NetworkError 그대로 전파
    func test_propagatesNetworkError() async {
        remote.nextError = NetworkError.transport(URLError(.notConnectedToInternet))

        let repo = BookDetailRepositoryImpl(remote: remote)

        do {
            _ = try await repo.fetchBookDetail(isbn13: "9781617294136")
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

    // 전달한 ISBN이 원격으로 그대로 전달된다
    func test_passesISBNToRemote() async throws {
        remote.nextDTO = MockDTO.detailOK

        let isbn = "1234567890123"
        _ = try await repo.fetchBookDetail(isbn13: isbn)

        XCTAssertEqual(remote.last_isbn13, isbn)
    }
}
