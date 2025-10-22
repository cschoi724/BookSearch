//
//  RemoteImageDataLoaderTests.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import XCTest
@testable import Infra

extension RemoteImageDataLoader: @unchecked @retroactive Sendable {}


final class RemoteImageDataLoaderTests: XCTestCase {

    private var cache: MemoryImageCache!
    private var loader: RemoteImageDataLoader!
    private var session: URLSession!

    override func setUp() {
        super.setUp()
        cache = MemoryImageCache()
        session = {
            let config = URLSessionConfiguration.ephemeral
            config.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: config)
        }()
        loader = RemoteImageDataLoader(cache: cache, session: session)
        MockURLProtocol.requestHandler = nil
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        cache = nil
        loader = nil
        session = nil
        super.tearDown()
    }

    // 캐시 히트 시 네트워크가 호출되면 안 된다
    func test_returnsCachedData_withoutNetworkCall() async throws {
        let url = URL(string: "https://itbook.store/img/books/image.png")!
        let cached = Data("cached".utf8)
        await cache.store(cached, for: url)

        let flag = CallFlag()
        MockURLProtocol.requestHandler = { _ in
            flag.set()
            let resp = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (resp, Data())
        }

        let result = try await loader.load(from: url)

        XCTAssertEqual(result, cached)
        XCTAssertFalse(flag.get(), "캐시가 있으면 네트워크 요청이 발생하면 안 됩니다.")
    }

    // 첫 다운로드 후 캐시에 저장
    func test_downloadsAndCachesImageData() async throws {
        let url = URL(string: "https://itbook.store/img/books/image.png")!
        let networkData = Data("network-image".utf8)

        MockURLProtocol.requestHandler = { req in
            let resp = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (resp, networkData)
        }

        let result = try await loader.load(from: url)
        XCTAssertEqual(result, networkData)

        let cached = await cache.data(for: url)
        XCTAssertEqual(cached, networkData)
    }

    // 중복 요청 합치기: 네트워크 호출 1회만
    func test_mergesConcurrentRequests_forSameURL() async throws {
        let url = URL(string: "https://itbook.store/img/books/image.png")!
        let networkData = Data("shared-image".utf8)

        let counter = Counter()

        MockURLProtocol.requestHandler = { req in
            counter.increment()
            Thread.sleep(forTimeInterval: 0.2)
            let resp = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (resp, networkData)
        }

        let loader = self.loader!
        async let a = loader.load(from: url)
        async let b = loader.load(from: url)
        async let c = loader.load(from: url)
        let results = try await [a, b, c]

        XCTAssertEqual(Set(results), [networkData])
        XCTAssertEqual(counter.value(), 1, "동일 URL 요청은 1회만 수행되어야 합니다.")
    }

    // 404 등 비정상 상태코드
    func test_throwsInvalidStatus_forNon200Response() async {
        let url = URL(string: "https://itbook.store/img/books/404.png")!

        MockURLProtocol.requestHandler = { req in
            let resp = HTTPURLResponse(url: req.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (resp, Data())
        }

        do {
            _ = try await loader.load(from: url)
            XCTFail("에러가 발생해야 합니다.")
        } catch let ImageLoaderError.invalidStatus(code) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("예상과 다른 에러: \(error)")
        }
    }
}
