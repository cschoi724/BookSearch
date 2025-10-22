//
//  SearchBookRemoteDataSourceTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra
@testable import Domain

final class SearchBookRemoteDataSourceTests: XCTestCase {

    private var client: NetworkClientStub!
    private var remote: SearchBookRemoteDataSource!

    override func setUp() {
        super.setUp()
        client = NetworkClientStub()
        remote = SearchBookRemoteDataSourceImpl(client: client)
    }

    override func tearDown() {
        remote = nil
        client = nil
        super.tearDown()
    }
    
    // 성공:200 OK이고 본문 error == "0" + 유효 JSON → DTO 디코딩 성공
    func test_returnsDTO_whenResponseOK() async throws {
        client.setNextResponse(status: 200, data: MockData.searchOK)
        let dto = try await remote.searchBooks(.init(query: "swift", page: 1))

        XCTAssertEqual(dto.error, "0")
        XCTAssertEqual(dto.page, "1")
        XCTAssertEqual(dto.total, "20")
        XCTAssertEqual(dto.books.count, 2)
        XCTAssertEqual(dto.books.first?.isbn13, "111")
    }
    
    // 요청 구성: 경로/쿼리 파라미터가 올바르게 반영되는가
    func test_buildsCorrectPathAndPage() async throws {
        client.setNextResponse(status: 200, data: MockData.searchOK)
        let request = SearchRequest(query: "swift", page: 3)

        _ = try await remote.searchBooks(request)

        guard let url = client.lastRequest?.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return XCTFail("URL 구성 실패")
        }
        
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "api.itbook.store")
        XCTAssertEqual(components.path, "/1.0/search/swift/3")
        XCTAssertTrue((components.queryItems ?? []).isEmpty)
    }

    // 200 OK이지만 본문 error != "0" 이면 플랫폼 에러를 던진다
    func test_throwsPlatformError_whenBodyErrorNonZero() async throws {
        client.setNextResponse(status: 200, data: MockData.searchError)

        do {
            _ = try await remote.searchBooks(.init(query: "swift", page: 1))
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
    func test_mapsStatusCodeError_toPlatformError() async throws {
        client.setNextResponse(status: 500, data: MockData.errorBody)
        
        do {
            _ = try await remote.searchBooks(.init(query: "swift", page: 1))
            XCTFail("에러가 발생해야 한다")
        } catch _ as ItBookAPIError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("예상치 못한 에러: \(error)")
        }
    }
}
