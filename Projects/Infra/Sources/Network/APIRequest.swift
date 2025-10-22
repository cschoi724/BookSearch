//
//  APIRequest.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol APIRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

public extension APIRequest {
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: Data? { nil }

    func buildURLRequest() throws -> URLRequest {
        let cleanPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let url = baseURL.appendingPathComponent(cleanPath)

        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        comps?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let finalURL = comps?.url else {
            throw NetworkError.invalidURL
        }

        var req = URLRequest(url: finalURL)
        req.httpMethod = method.rawValue
        if let body {
            req.httpBody = body
        }
        headers.forEach { key, value in
            req.setValue(value, forHTTPHeaderField: key)
        }
        return req
    }
}
