//
//  ItBookAPIEndpoint.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public enum ItBookAPIEndpoint {
    case search(request: SearchRequest)
    case detail(isbn13: String)
}

extension ItBookAPIEndpoint: APIRequest {

    public var baseURL: URL {
        URL(string: "https://api.itbook.store/1.0")!
    }

    public var path: String {
        switch self {
        case let .search(request):
            let (query, page) = (request.query, request.page)
            return page <= 1 ?
            "/search/\(query)" :
            "/search/\(query)/\(page)"
        case let .detail(isbn13):
            return "/books/\(isbn13)"
        }
    }

    public var method: HTTPMethod { .get }

    public var headers: [String : String] {
        ["Content-Type": "application/json"]
    }

    public var queryItems: [URLQueryItem]? { nil }

    public var body: Data? { nil }
}
