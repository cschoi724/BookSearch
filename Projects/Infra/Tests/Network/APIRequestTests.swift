//
//  APIRequestTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra

final class APIRequestTests: XCTestCase {

    // baseURL + path가 중복 슬래시 없이 합쳐져야 한다
    func test_joinsBaseAndPath() throws {
        let base = URL(string: "https://api.itbook.store/1.0")!

        // 선행 슬래시 없음
        let r1 = DummyRequest(
            baseURL: base,
            path: "books/9780000000000",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )
        let u1 = try r1.buildURLRequest().url!
        XCTAssertEqual(u1.absoluteString, "https://api.itbook.store/1.0/books/9780000000000")

        // 선행 슬래시 있음
        let r2 = DummyRequest(
            baseURL: base,
            path: "/books/9780000000000",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )
        let u2 = try r2.buildURLRequest().url!
        XCTAssertEqual(u2.absoluteString, "https://api.itbook.store/1.0/books/9780000000000")
    }

    // queryItems가 인코딩되어 URL에 반영되고 역파싱 시 값이 보존되어야 한다
    func test_appliesQueryItems() throws {
        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "search/swift/2",
            method: .get,
            headers: [:],
            queryItems: [
                .init(name: "q", value: "a b"),
                .init(name: "lang", value: "ko")
            ],
            body: nil
        )

        let urlRequest = try req.buildURLRequest()
        let comps = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)

        XCTAssertEqual(comps?.scheme, "https")
        XCTAssertEqual(comps?.host, "api.itbook.store")
        XCTAssertEqual(comps?.path, "/1.0/search/swift/2")

        let items = comps?.queryItems ?? []
        XCTAssertEqual(items.first(where: { $0.name == "q" })?.value, "a b")
        XCTAssertEqual(items.first(where: { $0.name == "lang" })?.value, "ko")
    }

    // HTTP 메서드/헤더/바디가 요청에 반영되어야 한다
    func test_setsMethodHeadersBody() throws {
        let body = Data("hello".utf8)
        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "echo",
            method: .post,
            headers: [
                "Content-Type": "application/json",
                "X-Debug": "1"
            ],
            queryItems: [],
            body: body
        )

        let urlRequest = try req.buildURLRequest()
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "X-Debug"), "1")
        XCTAssertEqual(urlRequest.httpBody, body)
    }

    // queryItems가 비어있으면 URL에 쿼리 문자열이 없어야 한다
    func test_omitsEmptyQuery() throws {
        let req = DummyRequest(
            baseURL: URL(string: "https://api.itbook.store/1.0")!,
            path: "ping",
            method: .get,
            headers: [:],
            queryItems: [],
            body: nil
        )

        let urlRequest = try req.buildURLRequest()
        let comps = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        XCTAssertNil(comps?.query)
    }
}
