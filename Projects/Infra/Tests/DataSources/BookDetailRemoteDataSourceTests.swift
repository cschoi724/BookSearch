//
//  BookDetailRemoteDataSourceTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra

final class BookDetailRemoteDataSourceTests: XCTestCase {

    private var client: NetworkClientStub!
    private var remote: BookDetailRemoteDataSource!

    override func setUp() {
        super.setUp()
        client = NetworkClientStub()
        remote = BookDetailRemoteDataSourceImpl(client: client)
    }

    override func tearDown() {
        remote = nil
        client = nil
        super.tearDown()
    }

    // 성공: 200 + 유효 JSON → DTO 디코딩 성공
    func test_returnsDTO_whenResponseOK() async throws {
        client.setNextResponse(status: 200, data: MockData.detailOK)

        let dto = try await remote.fetchBookDetail("9781617294136")

        XCTAssertEqual(dto.error, "0")
        XCTAssertEqual(dto.title, "Securing DevOps")
        XCTAssertEqual(dto.isbn13, "9781617294136")
    }

    // 요청 구성: 경로가 올바르게 반영되는가 (/books/{isbn13})
    func test_buildsCorrectPath() async throws {
        client.setNextResponse(status: 200, data: MockData.detailOK)

        let isbn = "9781617294136"
        _ = try await remote.fetchBookDetail(isbn)

        guard let url = client.lastRequest?.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return XCTFail("URL 구성 실패")
        }

        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "api.itbook.store")
        XCTAssertEqual(components.path, "/1.0/books/\(isbn)")
        XCTAssertTrue((components.queryItems ?? []).isEmpty)
    }

    // 200 OK이지만 본문 error != "0" 이면 플랫폼 에러를 던진다
    func test_throwsPlatformError_whenBodyErrorNonZero() async {
        client.setNextResponse(status: 200, data: MockData.detailError)

        do {
            _ = try await remote.fetchBookDetail("9781617294136")
            XCTFail("에러가 발생해야 한다")
        } catch let err as ItBookAPIError {
            switch err {
            case .platform(let code, _):
                XCTAssertNotEqual(code, 0)
            default:
                XCTFail("ItBookAPIError.platform 이어야 한다")
            }
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }

    // 4xx/5xx 상태코드면 매퍼가 바디의 error를 읽어 플랫폼 에러로 변환한다
    func test_mapsStatusCodeError_toPlatformError() async {
        client.setNextResponse(status: 500, data: MockData.errorBody)

        do {
            _ = try await remote.fetchBookDetail("9781617294136")
            XCTFail("에러가 발생해야 한다")
        } catch _ as ItBookAPIError {
            XCTAssertTrue(true) // 타입만 확인
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }
}
