//
//  MockURLProtocol.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

// URLSession을 가로채서 응답을 주입하기 위한 테스트 전용 URLProtocol
final class MockURLProtocol: URLProtocol {

    // 테스트마다 설정하는 요청 핸들러
    // 테스트 전용 전역 가변 상태 → 동시성 체크는 무시(nonisolated(unsafe))
    nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.requestHandler else {
            preconditionFailure("Set MockURLProtocol.requestHandler before starting the request.")
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
