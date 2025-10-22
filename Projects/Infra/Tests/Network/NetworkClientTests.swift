//
//  NetworkClientTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
import Foundation
@testable import Infra

private struct TestDTO: Codable, Equatable { let value: String }

final class NetworkClientTests: XCTestCase {

    private func makeClient() -> DefaultNetworkClient {
        // MockURLProtocol 주입된 세션
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return DefaultNetworkClient(
            session: session,
            logger: nil
        )
    }

    override func tearDown() {
        super.tearDown()
        MockURLProtocol.requestHandler = nil
    }

    // 성공 디코딩
    // 검색 유즈케이스: 정상 응답을 디코딩해야 한다
    func test_request_decodesSuccess() async throws {
        let client = makeClient()

        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "ping/success",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )

        // 200 + 유효 JSON
        MockURLProtocol.requestHandler = { request in
            let data = try JSONEncoder().encode(TestDTO(value: "ok"))
            let url = request.url!
            let resp = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
            return (resp, data)
        }
        defer { MockURLProtocol.requestHandler = nil }
        let dto = try await client.request(req, as: TestDTO.self, decoder: .init())
        XCTAssertEqual(dto, TestDTO(value: "ok"))
    }

    // HTTP 에러 전달
    // 네트워크 클라이언트는 비 2xx 상태코드를 NetworkError.statusCode로 던져야 한다
    func test_request_throwsStatusCodeError() async {
        let client = makeClient()

        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "ping/404",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )

        // 404
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            let resp = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (resp, Data())
        }
        defer { MockURLProtocol.requestHandler = nil }

        do {
            _ = try await client.request(req, as: TestDTO.self, decoder: .init())
            XCTFail("에러가 발생해야 합니다.")
        } catch let NetworkError.statusCode(code, _) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("예상과 다른 에러: \(error)")
        }
    }

    // 전송(Transport) 에러 전달
    // 네트워크 클라이언트는 URLError를 NetworkError.transport로 감싸서 던져야 한다
    func test_request_throwsTransportError() async {
        let client = makeClient()

        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "ping/transport",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )

        // URLProtocol에서 전송 에러 throw
        enum Dummy: Error { case transport }
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }
        defer { MockURLProtocol.requestHandler = nil }

        do {
            _ = try await client.request(req, as: TestDTO.self, decoder: .init())
            XCTFail("에러가 발생해야 합니다.")
        } catch let NetworkError.transport(urlErr) {
            XCTAssertEqual((urlErr as? URLError)?.code, .notConnectedToInternet)
        } catch {
            XCTFail("예상과 다른 에러: \(error)")
        }
    }

    // 디코딩 에러 전달
    // 네트워크 클라이언트는 디코딩 실패를 NetworkError.decoding으로 던져야 한다
    func test_request_throwsDecodingError() async {
        let client = makeClient()

        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "ping/invalid-json",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )

        // 200 + 잘못된 JSON 구조
        let invalidJSON = Data(#"{"value": 123}"#.utf8)
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            let resp = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
            return (resp, invalidJSON)
        }
        defer { MockURLProtocol.requestHandler = nil }

        do {
            _ = try await client.request(req, as: TestDTO.self, decoder: .init())
            XCTFail("에러가 발생해야 합니다.")
        } catch let NetworkError.decoding(_, data) {
            XCTAssertEqual(data, invalidJSON)
        } catch {
            XCTFail("예상과 다른 에러: \(error)")
        }
    }

    // URL 조립 검증
    // APIRequest의 path와 queryItems로 올바른 URL이 만들어져야 한다
    func test_buildURLRequest_constructsURLWithQuery() throws {
        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "search/swift/2",
            method: .get,
            headers: [:],
            queryItems: [
                .init(name: "q", value: "a b"),    // 인코딩 확인용
                .init(name: "lang", value: "ko")
            ],
            body: nil
        )
        let urlRequest = try req.buildURLRequest()
        let comps = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(comps?.scheme, "https")
        XCTAssertEqual(comps?.host, "api.itbook.store")
        XCTAssertEqual(comps?.path, "/1.0/search/swift/2")
        let queryItems = comps?.queryItems ?? []
        XCTAssertEqual(queryItems.first(where: { $0.name == "q" })?.value, "a b")
        XCTAssertEqual(queryItems.first(where: { $0.name == "lang" })?.value, "ko")
    }
}
