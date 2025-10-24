//
//  SearchRequest.swift
//  Domain
//
//  Created by 일하는석찬 on 10/21/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public struct SearchRequest: Equatable, Sendable {
    public let query: String
    public let page: Int

    public init(query: String, page: Int = 1) {
        self.query = query
        self.page = page
    }

    public func next() -> SearchRequest {
        SearchRequest(query: query, page: page + 1)
    }
}
