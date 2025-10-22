//
//  NetworkClientStub.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
@testable import Infra

final class NetworkClientStub: NetworkClient {
    
    private var nextError: Error?
    private var nextStatus: Int = 200
    private var nextData: Data?
    private(set) var lastRequest: URLRequest?

    func setNextResponse(status: Int = 200, data: Data?) {
        nextStatus = status
        nextData = data
        nextError = nil
    }

    func setNextError(_ error: Error) {
        nextError = error
        nextData = nil
    }
    
    func request<T: Decodable>(_ endpoint: APIRequest, as type: T.Type, decoder: JSONDecoder) async throws -> T {
        let data = try await requestData(endpoint)
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decoding(error, data)
        }
    }

    func requestData(_ endpoint: APIRequest) async throws -> Data {
        let urlRequest = try endpoint.buildURLRequest()
        lastRequest = urlRequest

        if let error = nextError {
            throw error
        }

        guard (200..<300).contains(nextStatus) else {
            throw NetworkError.statusCode(nextStatus, nextData)
        }

        guard let data = nextData else {
            throw NetworkError.decoding(NSError(domain: "NoData", code: -1), nil)
        }

        return data
    }
}
